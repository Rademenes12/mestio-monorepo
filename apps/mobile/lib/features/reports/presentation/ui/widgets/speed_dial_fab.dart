import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../l10n/l10n.dart';

class SpeedDialFab extends StatefulWidget {
  const SpeedDialFab({
    super.key,
    required this.onReportIssue,
    required this.onScanQr,
    required this.onMessageToBoard,
    required this.noEstateMessage,
  });

  final VoidCallback? onReportIssue;
  final VoidCallback? onScanQr;
  final VoidCallback? onMessageToBoard;
  final String noEstateMessage;

  @override
  State<SpeedDialFab> createState() => SpeedDialFabState();
}

class SpeedDialFabState extends State<SpeedDialFab>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  late final AnimationController _controller;
  late final Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 0.375,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _onAction(VoidCallback? action) {
    _toggle();
    if (action == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.noEstateMessage)),
      );
      return;
    }
    action.call();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isOpen) ...[
          FabActionItem(
            icon: Icons.message_outlined,
            label: l10n.fabMessageToBoard,
            color: AppColors.amber,
            onTap: () => _onAction(widget.onMessageToBoard),
          ),
          const SizedBox(height: 12),
          FabActionItem(
            icon: Icons.qr_code_scanner,
            label: l10n.fabScanQr,
            color: AppColors.azure,
            onTap: () => _onAction(widget.onScanQr),
          ),
          const SizedBox(height: 12),
          FabActionItem(
            icon: Icons.report_problem_outlined,
            label: l10n.fabReportIssue,
            color: AppColors.mint,
            onTap: () => _onAction(widget.onReportIssue),
          ),
          const SizedBox(height: 16),
        ],
        Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [AppColors.azure, AppColors.blueprint],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _toggle,
              customBorder: const CircleBorder(),
              child: RotationTransition(
                turns: _rotateAnimation,
                child: Icon(
                  _isOpen ? Icons.close : Icons.add,
                  size: 28,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FabActionItem extends StatelessWidget {
  const FabActionItem({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.lightCard,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
