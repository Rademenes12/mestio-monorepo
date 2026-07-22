import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../../auth/data/repositories/auth_repository.dart';
import '../../../profiles/models/resident_profile_model.dart';
import '../../../../shared/role_display.dart';
import '../../../../shared/error_messages.dart';
import '../../../../shared/widgets/consent_text.dart';
import '../../../../shared/widgets/logout_feedback_sheet.dart';
import '../../../estate/presentation/cubit/estate_cubit.dart' as membership;
import '../cubit/reports_cubit.dart';

/// Registration entry point shown when the signed-in user has no verified
/// profile yet. The invitation code determines the role - it is never
/// picked manually (closes the "anyone can make themselves board" hole).
///
/// Flow:
///  1. Name, phone, invitation code -> code is validated (peek) to learn the
///     role + estate before asking role-specific questions.
///  2. Role-specific step: resident picks their unit, technician names their
///     company, other staff roles have nothing extra to fill in.
///  3. Summary -> redeem. Residents join immediately; other staff roles are
///     queued in fixflow_join_requests until the office approves them, and
///     see [_PendingApprovalView] on this and future app opens.
class LockScreen extends StatefulWidget {
  final String? initialEmail;

  const LockScreen({super.key, this.initialEmail});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _companyController = TextEditingController();

  String _selectedBuilding = 'Budynek 1';
  String _selectedFootbridge = 'Klatka A';
  String _selectedFloor = 'Parter';
  String _selectedApartment = '';

  static const _buildings = ['Budynek 1', 'Budynek 2', 'Budynek 3'];
  static const _footbridges = ['Klatka A', 'Klatka B', 'Klatka C'];
  static const _floors = [
    'Parter',
    'Piętro 1',
    'Piętro 2',
    'Piętro 3',
    'Piętro 4',
  ];

  int _currentStep = 0;
  final _step0FormKey = GlobalKey<FormState>();
  final _step1FormKey = GlobalKey<FormState>();

  bool _isBusy = false;
  String? _stepErrorKey;

  // GDPR Article 7(1): every new user (guest or registered) passes through
  // this screen before any real PII (name/phone/apartment) is collected -
  // this is where consent must be captured and persisted (termsAcceptedAt).
  bool _acceptedTerms = false;

  // Populated once the invitation code is validated (peek) in step 0.
  String? _detectedRoleDb;
  String _estateName = '';

  // Gate: does the user already have a join request awaiting approval from
  // a previous attempt? Checked once so re-opening the app doesn't restart
  // the wizard for staff roles that are still pending.
  bool _checkingPending = true;
  Map<String, dynamic>? _pendingRequest;

  String get _resolvedEmail => widget.initialEmail ?? '';

  bool get _isResident => _detectedRoleDb == null || _detectedRoleDb == 'resident';
  bool get _isTechnician => _detectedRoleDb == 'technician';
  bool get _hasLocationStep => _isResident || _isTechnician;
  int get _lastStepIndex => _hasLocationStep ? 2 : 1;

  @override
  void initState() {
    super.initState();
    _checkPending();
  }

  Future<void> _checkPending() async {
    final pending =
        await context.read<membership.EstateMembershipCubit>().checkPendingRequest();
    if (!mounted) return;
    setState(() {
      _pendingRequest = pending;
      _checkingPending = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _codeController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  Future<void> _onNext() async {
    if (_currentStep == 0) {
      if (!(_step0FormKey.currentState?.validate() ?? false)) return;
      if (!_acceptedTerms) {
        setState(() => _stepErrorKey = 'terms_not_accepted');
        return;
      }
      await _validateCodeAndAdvance();
      return;
    }
    if (_hasLocationStep && _currentStep == 1) {
      if (!(_step1FormKey.currentState?.validate() ?? false)) return;
    }
    setState(() => _currentStep += 1);
  }

  Future<void> _validateCodeAndAdvance() async {
    final cubit = context.read<membership.EstateMembershipCubit>();
    setState(() {
      _isBusy = true;
      _stepErrorKey = null;
    });
    final result = await cubit.peekCode(_codeController.text.trim());
    if (!mounted) return;
    if (result == null) {
      final state = cubit.state;
      setState(() {
        _isBusy = false;
        _stepErrorKey = state is membership.EstateLoaded ? state.errorKey : 'unknown_error';
      });
      return;
    }
    setState(() {
      _isBusy = false;
      _detectedRoleDb = result['role'] as String;
      _estateName = result['estate_name'] as String? ?? '';
      _currentStep = 1;
    });
  }

  Future<void> _submit() async {
    if (_hasLocationStep) {
      if (!(_step1FormKey.currentState?.validate() ?? false)) {
        setState(() => _currentStep = 1);
        return;
      }
    }

    final cubit = context.read<membership.EstateMembershipCubit>();
    setState(() {
      _isBusy = true;
      _stepErrorKey = null;
    });

    final result = await cubit.redeemCode(
      _codeController.text.trim(),
      building: _isResident ? _selectedBuilding : null,
      stairwell: _isResident ? _selectedFootbridge : null,
      floor: _isResident ? _selectedFloor : null,
      apartment: _isResident ? _selectedApartment : null,
      info: _isTechnician ? _companyController.text.trim() : null,
    );

    if (!mounted) return;

    if (result == null) {
      final state = cubit.state;
      setState(() {
        _isBusy = false;
        _stepErrorKey = state is membership.EstateLoaded ? state.errorKey : 'unknown_error';
      });
      return;
    }

    final status = result['status'] as String? ?? 'joined';
    final role = _detectedRoleDb ?? (result['role'] as String? ?? 'resident');
    setState(() => _isBusy = false);

    if (status == 'pending') {
      setState(() => _pendingRequest = {
            'role': role,
            'fixflow_estates': {'name': _estateName},
          });
      return;
    }

    // status == 'joined': resident, membership already created server-side.
    if (!mounted) return;
    final profile = ResidentProfileModel(
      name: _nameController.text.trim(),
      email: _resolvedEmail,
      phone: _phoneController.text.trim(),
      verificationCode: _codeController.text.trim(),
      building: _selectedBuilding,
      footbridge: _selectedFootbridge,
      floor: _selectedFloor,
      apartment: 'Mieszkanie $_selectedApartment',
      isVerified: true,
      termsAcceptedAt: DateTime.now(),
      role: dbRoleToLabel(role),
      companyName: '',
    );
    context.read<ReportsCubit>().saveProfile(profile);
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingPending) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_pendingRequest != null) {
      return _PendingApprovalView(
        estateName: (_pendingRequest!['fixflow_estates']
                as Map<String, dynamic>?)?['name'] as String? ??
            _estateName,
        role: dbRoleToLabel(_pendingRequest!['role'] as String),
      );
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = context.l10n;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.lightCanvas,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppColors.spacingSm,
              vertical: AppColors.spacingSm,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppColors.radiusCard),
                ),
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.apartment,
                          size: 40,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.lockScreenTitle,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.lockScreenStaffSubtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark ? Colors.grey.shade400 : Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      _StepIndicator(
                        currentStep: _currentStep,
                        lastStepIndex: _lastStepIndex,
                        hasLocationStep: _hasLocationStep,
                        l10n: l10n,
                      ),
                      const SizedBox(height: 16),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: _stepContent(isDark, l10n),
                      ),
                      const SizedBox(height: 8),
                      if (_stepErrorKey != null) ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: SelectableText(
                            messageForErrorKey(l10n, _stepErrorKey),
                            style: const TextStyle(color: Colors.red, fontSize: 13),
                          ),
                        ),
                      ],
                      _StepButtons(
                        currentStep: _currentStep,
                        lastStepIndex: _lastStepIndex,
                        isBusy: _isBusy,
                        onBack: () => setState(() => _currentStep -= 1),
                        onNext: _isBusy ? null : _onNext,
                        onSubmit: _isBusy ? null : _submit,
                        l10n: l10n,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _stepContent(bool isDark, AppLocalizations l10n) {
    if (_currentStep == 0) {
      return _Step0BasicInfo(
        key: const ValueKey('step0'),
        formKey: _step0FormKey,
        nameController: _nameController,
        phoneController: _phoneController,
        codeController: _codeController,
        isDark: isDark,
        l10n: l10n,
        acceptedTerms: _acceptedTerms,
        onAcceptedTermsChanged: (v) => setState(() {
          _acceptedTerms = v;
          if (v) _stepErrorKey = null;
        }),
      );
    }
    if (_hasLocationStep && _currentStep == 1) {
      return _isTechnician
          ? _Step1Company(
              key: const ValueKey('step1-company'),
              formKey: _step1FormKey,
              companyController: _companyController,
              isDark: isDark,
              l10n: l10n,
            )
          : _Step1Location(
              key: const ValueKey('step1-location'),
              formKey: _step1FormKey,
              isDark: isDark,
              l10n: l10n,
              buildings: _buildings,
              footbridges: _footbridges,
              floors: _floors,
              selectedBuilding: _selectedBuilding,
              selectedFootbridge: _selectedFootbridge,
              selectedFloor: _selectedFloor,
              onBuildingChanged: (v) => setState(() => _selectedBuilding = v),
              onFootbridgeChanged: (v) => setState(() => _selectedFootbridge = v),
              onFloorChanged: (v) => setState(() => _selectedFloor = v),
              onApartmentChanged: (v) => _selectedApartment = v,
            );
    }
    return _StepSummary(
      key: const ValueKey('summary'),
      l10n: l10n,
      role: dbRoleToLabel(_detectedRoleDb ?? 'resident'),
      estateName: _estateName,
      name: _nameController.text,
      isResident: _isResident,
      isTechnician: _isTechnician,
      location:
          '$_selectedBuilding · $_selectedFootbridge · $_selectedFloor · m. $_selectedApartment',
      company: _companyController.text,
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({
    required this.currentStep,
    required this.lastStepIndex,
    required this.hasLocationStep,
    required this.l10n,
  });

  final int currentStep;
  final int lastStepIndex;
  final bool hasLocationStep;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final labels = hasLocationStep
        ? [l10n.stepBasicDataTitle, l10n.stepLocationTitle, l10n.stepSummaryTitle]
        : [l10n.stepBasicDataTitle, l10n.stepSummaryTitle];

    return Row(
      children: List.generate(labels.length, (i) {
        final isActive = i == currentStep;
        final isCompleted = currentStep > i;
        final bgColor = isActive
            ? AppColors.electricIndigo
            : isCompleted
                ? AppColors.neonMint
                : Colors.grey.shade300;
        final textColor = isActive || isCompleted ? Colors.white : Colors.grey;

        return Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                child: isCompleted
                    ? Icon(Icons.check, size: 16, color: textColor)
                    : Center(
                        child: Text(
                          '${i + 1}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 4),
              Text(
                labels[i],
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive
                      ? AppColors.lightTextPrimary
                      : AppColors.lightTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _Step0BasicInfo extends StatelessWidget {
  const _Step0BasicInfo({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.codeController,
    required this.isDark,
    required this.l10n,
    required this.acceptedTerms,
    required this.onAcceptedTermsChanged,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController codeController;
  final bool isDark;
  final AppLocalizations l10n;
  final bool acceptedTerms;
  final ValueChanged<bool> onAcceptedTermsChanged;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : Colors.black87;
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: nameController,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              labelText: l10n.fullNameFieldLabel,
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            validator: (v) =>
                v == null || v.trim().isEmpty ? l10n.fullNameRequired : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: phoneController,
            style: TextStyle(color: textColor),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: l10n.phoneFieldLabelRequired,
              prefixIcon: const Icon(Icons.phone_outlined),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            validator: (v) {
              final value = v?.trim() ?? '';
              if (value.isEmpty) return l10n.phoneRequired;
              final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
              if (digitsOnly.length < 7) return l10n.phoneInvalid;
              return null;
            },
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: codeController,
            textCapitalization: TextCapitalization.characters,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              labelText: l10n.codeFieldLabelRequired,
              prefixIcon: const Icon(Icons.vpn_key),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            validator: (v) =>
                v == null || v.trim().isEmpty ? l10n.codeRequired : null,
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.codeExplanation,
              style: TextStyle(
                fontSize: 11.5,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  value: acceptedTerms,
                  onChanged: (v) => onAcceptedTermsChanged(v ?? false),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: ConsentText(isDark: isDark, l10n: l10n),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Step1Location extends StatelessWidget {
  const _Step1Location({
    super.key,
    required this.formKey,
    required this.isDark,
    required this.l10n,
    required this.buildings,
    required this.footbridges,
    required this.floors,
    required this.selectedBuilding,
    required this.selectedFootbridge,
    required this.selectedFloor,
    required this.onBuildingChanged,
    required this.onFootbridgeChanged,
    required this.onFloorChanged,
    required this.onApartmentChanged,
  });

  final GlobalKey<FormState> formKey;
  final bool isDark;
  final AppLocalizations l10n;
  final List<String> buildings;
  final List<String> footbridges;
  final List<String> floors;
  final String selectedBuilding;
  final String selectedFootbridge;
  final String selectedFloor;
  final ValueChanged<String> onBuildingChanged;
  final ValueChanged<String> onFootbridgeChanged;
  final ValueChanged<String> onFloorChanged;
  final ValueChanged<String> onApartmentChanged;

  @override
  Widget build(BuildContext context) {
    final dropdownColor = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final textStyle = TextStyle(
      color: isDark ? Colors.white : Colors.black87,
      fontSize: 13,
    );
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
              child: Text(
                l10n.locationSectionLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: selectedBuilding,
                  dropdownColor: dropdownColor,
                  style: textStyle,
                  decoration: InputDecoration(
                    labelText: l10n.buildingFieldLabel,
                    border: const OutlineInputBorder(),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: buildings
                      .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                      .toList(),
                  onChanged: (val) => val == null ? null : onBuildingChanged(val),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: selectedFootbridge,
                  dropdownColor: dropdownColor,
                  style: textStyle,
                  decoration: InputDecoration(
                    labelText: l10n.footbridgeFieldLabel,
                    border: const OutlineInputBorder(),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: footbridges
                      .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                      .toList(),
                  onChanged: (val) => val == null ? null : onFootbridgeChanged(val),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: selectedFloor,
                  dropdownColor: dropdownColor,
                  style: textStyle,
                  decoration: InputDecoration(
                    labelText: l10n.floorFieldLabel,
                    border: const OutlineInputBorder(),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: floors
                      .map((fl) => DropdownMenuItem(value: fl, child: Text(fl)))
                      .toList(),
                  onChanged: (val) => val == null ? null : onFloorChanged(val),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  style: textStyle,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.apartmentFieldLabel,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  onChanged: (val) => onApartmentChanged(val.trim()),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? l10n.requiredFieldShort : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Step1Company extends StatelessWidget {
  const _Step1Company({
    super.key,
    required this.formKey,
    required this.companyController,
    required this.isDark,
    required this.l10n,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController companyController;
  final bool isDark;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
              child: Text(
                l10n.technicianCompanyTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ),
          TextFormField(
            controller: companyController,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 13,
            ),
            decoration: InputDecoration(
              labelText: l10n.technicianCompanyLabel,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            validator: (v) => v == null || v.trim().isEmpty
                ? l10n.technicianCompanyRequired
                : null,
          ),
        ],
      ),
    );
  }
}

class _StepSummary extends StatelessWidget {
  const _StepSummary({
    super.key,
    required this.l10n,
    required this.role,
    required this.estateName,
    required this.name,
    required this.isResident,
    required this.isTechnician,
    required this.location,
    required this.company,
  });

  final AppLocalizations l10n;
  final String role;
  final String estateName;
  final String name;
  final bool isResident;
  final bool isTechnician;
  final String location;
  final String company;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('summary-content'),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _SummaryRow(label: l10n.regSummaryRoleLabel, value: roleDisplayLabel(role)),
        _SummaryRow(label: l10n.regSummaryEstateLabel, value: estateName),
        _SummaryRow(label: l10n.regSummaryNameLabel, value: name),
        if (isResident) _SummaryRow(label: l10n.regSummaryLocationLabel, value: location),
        if (isTechnician) _SummaryRow(label: l10n.regSummaryCompanyLabel, value: company),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F7FB),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            isResident ? l10n.regResidentJoinNote : l10n.regPendingApprovalNote,
            style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.5),
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[500])),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepButtons extends StatelessWidget {
  const _StepButtons({
    required this.currentStep,
    required this.lastStepIndex,
    required this.isBusy,
    required this.onBack,
    required this.onNext,
    required this.onSubmit,
    required this.l10n,
  });

  final int currentStep;
  final int lastStepIndex;
  final bool isBusy;
  final VoidCallback onBack;
  final VoidCallback? onNext;
  final VoidCallback? onSubmit;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isLast = currentStep >= lastStepIndex;
    final hasBackButton = currentStep > 0;

    return Row(
      mainAxisAlignment:
          hasBackButton ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
      children: [
        if (hasBackButton)
          TextButton(
            onPressed: isBusy ? null : onBack,
            child: Text(l10n.backButtonLabel),
          ),
        if (!isLast)
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.electricIndigo,
              foregroundColor: Colors.white,
              minimumSize: const Size(0, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppColors.radiusButton),
              ),
            ),
            child: isBusy
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : Text(l10n.nextButtonLabel),
          )
        else
          ElevatedButton(
            onPressed: onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.electricIndigo,
              foregroundColor: Colors.white,
              minimumSize: const Size(0, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppColors.radiusButton),
              ),
              elevation: 0,
            ),
            child: isBusy
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      l10n.confirmAndOpenButton,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
          ),
      ],
    );
  }
}

/// Shown instead of the wizard when the user has a pending join request
/// (staff role awaiting office approval). "Check status" reloads the
/// profile; once approved server-side, AppGate navigates to the dashboard.
class _PendingApprovalView extends StatelessWidget {
  const _PendingApprovalView({required this.estateName, required this.role});

  final String estateName;
  final String role;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.lightCanvas,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.amberAlert.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.hourglass_top,
                      size: 40,
                      color: AppColors.amberAlert,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.pendingApprovalTitle,
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.pendingApprovalBody(
                      estateName,
                      roleDisplayLabel(role),
                    ),
                    style: const TextStyle(fontSize: 14, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.read<ReportsCubit>().retry(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.electricIndigo,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppColors.radiusButton),
                        ),
                      ),
                      child: Text(l10n.pendingApprovalRefreshButton),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => showLogoutFeedbackSheet(
                      context: context,
                      onConfirmLogout: () => getIt<AuthRepository>().signOut(),
                    ),
                    child: Text(l10n.logoutButtonLabel),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
