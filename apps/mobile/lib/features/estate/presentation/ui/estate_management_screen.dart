import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/role_display.dart';
import '../../data/repositories/estate_repository.dart';
import '../cubit/estate_cubit.dart';
import 'widgets/estate_health_card.dart';

/// Roles that can be granted via an invitation code (MASTER_BUILD par.10).
/// Resident auto-joins; the rest queue in fixflow_join_requests for office
/// approval (board approves admin; admin/board approve technician/security).
const _manageableRoles = ['resident', 'technician', 'security', 'admin', 'board'];

class EstateManagementScreen extends StatelessWidget {
  const EstateManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EstateMembershipCubit>(
      create: (_) => getIt<EstateMembershipCubit>(),
      child: const _EstateManagementView(),
    );
  }
}

class _EstateManagementView extends StatefulWidget {
  const _EstateManagementView();

  @override
  State<_EstateManagementView> createState() => _EstateManagementViewState();
}

class _EstateManagementViewState extends State<_EstateManagementView> {
  final Map<String, String?> _codes = {};
  final Map<String, bool> _loadingCode = {};
  List<Map<String, dynamic>> _joinRequests = [];
  bool _loadingRequests = false;
  bool _initialLoadDone = false;
  Map<String, dynamic>? _healthData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialLoadDone) {
      _initialLoadDone = true;
      _loadAll();
    }
  }

  String? _activeEstateId() {
    final state = context.read<EstateMembershipCubit>().state;
    return switch (state) {
      EstateLoaded(activeEstate: final e?) => e.id,
      _ => null,
    };
  }

  Future<void> _loadAll() async {
    final estateId = _activeEstateId();
    if (estateId == null) return;
    final repo = getIt<EstateRepository>();
    _loadHealthIndex(repo, estateId);
    await Future.wait([
      ..._manageableRoles.map((role) => _loadCode(estateId, role)),
      _loadJoinRequests(estateId),
    ]);
  }

  Future<void> _loadHealthIndex(EstateRepository repo, String estateId) async {
    try {
      final data = await repo.getHealthIndex(estateId);
      if (mounted) setState(() => _healthData = data);
    } catch (_) {
      if (mounted) setState(() => _healthData = null);
    }
  }

  Future<void> _loadCode(String estateId, String role) async {
    try {
      final code =
          await getIt<EstateRepository>().getActiveInvitationCode(estateId, role: role);
      if (mounted) setState(() => _codes[role] = code);
    } catch (_) {}
  }

  Future<void> _generateCode(String estateId, String role) async {
    setState(() => _loadingCode[role] = true);
    try {
      final code =
          await getIt<EstateRepository>().createInvitationCode(estateId, role: role);
      if (!mounted) return;
      setState(() => _codes[role] = code);
    } catch (_) {
      // Errors here are rare (RLS already gates isOffice); a silent no-op
      // keeps the card in its previous state rather than showing a raw key.
    } finally {
      if (mounted) setState(() => _loadingCode[role] = false);
    }
  }

  Future<void> _regenerateCode(BuildContext cardContext, String estateId, String role) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: cardContext,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.estateRegenerateCodeTitle),
        content: Text(l10n.estateRegenerateCodeBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.commonNo),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.commonYes),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _generateCode(estateId, role);
    }
  }

  Future<void> _loadJoinRequests(String estateId) async {
    setState(() => _loadingRequests = true);
    try {
      final requests = await getIt<EstateRepository>().getPendingJoinRequests(estateId);
      if (mounted) setState(() => _joinRequests = requests);
    } catch (_) {
    } finally {
      if (mounted) setState(() => _loadingRequests = false);
    }
  }

  Future<void> _approve(String requestId) async {
    final estateId = _activeEstateId();
    try {
      await getIt<EstateRepository>().approveJoinRequest(requestId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.estateJoinRequestApprovedSnackbar)),
      );
      if (estateId != null) await _loadJoinRequests(estateId);
    } catch (_) {}
  }

  Future<void> _reject(String requestId) async {
    final estateId = _activeEstateId();
    try {
      await getIt<EstateRepository>().rejectJoinRequest(requestId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.estateJoinRequestRejectedSnackbar)),
      );
      if (estateId != null) await _loadJoinRequests(estateId);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.estateInvitationCodeTitle)),
      body: SafeArea(
        child: BlocBuilder<EstateMembershipCubit, EstateState>(
          builder: (context, state) {
            final active = state is EstateLoaded ? state.activeEstate : null;

            if (active == null) {
              return Center(child: Text(l10n.estateOnboardingSubtitle));
            }

            if (!active.isOffice) {
              // Non-office members (residents/technician/security) don't
              // manage codes or approvals; nothing to show here.
              return Center(child: Text(active.name));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    active.name,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // Estate health index (prototype)
                  if (_healthData != null) ...[
                    EstateHealthCard(
                      score: (_healthData!['score'] as int?) ?? 0,
                      label: (_healthData!['label'] as String?) ?? '—',
                      color: _parseHealthColor((_healthData!['color'] as String?) ?? '#6B7A90'),
                      openReports: (_healthData!['open_reports'] as int?) ?? 0,
                      overdueReports: (_healthData!['overdue_reports'] as int?) ?? 0,
                      totalReports: (_healthData!['total_reports'] as int?) ?? 0,
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        l10n.estateHealthPrototypeLabel,
                        style: const TextStyle(color: AppColors.lightTextSecondary, fontSize: 11),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    l10n.estateCodeRolesSectionTitle,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  ..._manageableRoles.map(
                    (role) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _RoleCodeCard(
                        role: role,
                        code: _codes[role],
                        isLoading: _loadingCode[role] ?? false,
                        onGenerate: () => _generateCode(active.id, role),
                        onRegenerate: (ctx) => _regenerateCode(ctx, active.id, role),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.estateJoinRequestsTitle,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  _JoinRequestsList(
                    requests: _joinRequests,
                    isLoading: _loadingRequests,
                    onApprove: _approve,
                    onReject: _reject,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RoleCodeCard extends StatelessWidget {
  const _RoleCodeCard({
    required this.role,
    required this.code,
    required this.isLoading,
    required this.onGenerate,
    required this.onRegenerate,
  });

  final String role;
  final String? code;
  final bool isLoading;
  final VoidCallback onGenerate;
  final void Function(BuildContext cardContext) onRegenerate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isAutoJoin = role == 'resident';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    roleDisplayLabel(dbRoleToLabel(role)),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: (isAutoJoin ? Colors.green : Colors.orange).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    isAutoJoin
                        ? l10n.estateAutoJoinBadge
                        : l10n.estateApprovalRequiredBadge,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isAutoJoin ? Colors.green.shade800 : Colors.orange.shade800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (code != null) ...[
              Row(
                children: [
                  Expanded(
                    child: SelectableText(
                      code!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 20),
                    tooltip: l10n.estateCopyCodeButton,
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: code!));
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.estateCodeCopiedSnackbar)),
                      );
                    },
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  icon: const Icon(Icons.refresh, size: 16),
                  label: Text(l10n.estateRegenerateCodeButton),
                  onPressed: isLoading ? null : () => onRegenerate(context),
                ),
              ),
            ] else
              Align(
                alignment: Alignment.centerLeft,
                child: FilledButton(
                  onPressed: isLoading ? null : onGenerate,
                  child: isLoading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.estateGenerateCodeButton),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _JoinRequestsList extends StatelessWidget {
  const _JoinRequestsList({
    required this.requests,
    required this.isLoading,
    required this.onApprove,
    required this.onReject,
  });

  final List<Map<String, dynamic>> requests;
  final bool isLoading;
  final ValueChanged<String> onApprove;
  final ValueChanged<String> onReject;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (isLoading) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(16),
        child: CircularProgressIndicator(),
      ));
    }
    if (requests.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          l10n.estateJoinRequestsEmpty,
          style: TextStyle(color: Colors.grey.shade600),
        ),
      );
    }
    return Column(
      children: requests.map((req) {
        final id = req['id'] as String;
        final role = req['role'] as String;
        final info = req['info'] as String?;
        return Card(
          child: ListTile(
            title: Text(roleDisplayLabel(dbRoleToLabel(role))),
            subtitle: info != null && info.isNotEmpty ? Text(info) : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () => onReject(id),
                  child: Text(l10n.estateRejectButton),
                ),
                FilledButton(
                  onPressed: () => onApprove(id),
                  child: Text(l10n.estateApproveButton),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
Color _parseHealthColor(String hex) {
  try {
    final raw = hex.replaceFirst('#', '');
    return Color(int.parse('FF$raw', radix: 16));
  } catch (_) {
    return AppColors.muted;
  }
}

