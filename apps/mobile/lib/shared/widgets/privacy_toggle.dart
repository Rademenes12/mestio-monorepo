import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Erste "Tryb dyskretny" inspired privacy toggle for Flutter.
///
/// Wraps children and hides sensitive data when privacy mode is active.
/// Use [PrivacyToggle.of(context)] to get the current state anywhere in the subtree.
class PrivacyToggle extends StatefulWidget {
  final Widget child;

  const PrivacyToggle({super.key, required this.child});

  /// Access the nearest [PrivacyToggleState] from the build context.
  static PrivacyToggleState of(BuildContext context) {
    final state = context.findAncestorStateOfType<PrivacyToggleState>();
    assert(state != null, 'PrivacyToggle not found in widget tree');
    return state!;
  }

  @override
  State<PrivacyToggle> createState() => PrivacyToggleState();
}

class PrivacyToggleState extends State<PrivacyToggle> {
  bool _hidden = false;

  bool get isHidden => _hidden;

  void toggle() => setState(() => _hidden = !_hidden);

  /// Conceal a value if privacy mode is active.
  String conceal(String value) {
    if (!_hidden) return value;
    if (value.length <= 4) return '••••';
    return '${value.substring(0, 2)}••••${value.substring(value.length - 2)}';
  }

  String concealInt(int value) => conceal('$value');

  @override
  Widget build(BuildContext context) => widget.child;
}

/// A small button to toggle privacy mode.
class PrivacyToggleButton extends StatelessWidget {
  const PrivacyToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = PrivacyToggle.of(context);
    return GestureDetector(
      onTap: state.toggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: state.isHidden
              ? AppColors.error.withValues(alpha: 0.1)
              : AppColors.accent.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: state.isHidden
                ? AppColors.error.withValues(alpha: 0.2)
                : AppColors.accent.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              state.isHidden ? Icons.visibility_off : Icons.visibility,
              size: 16,
              color: state.isHidden ? AppColors.error : AppColors.accent,
            ),
            const SizedBox(width: 4),
            Text(
              state.isHidden ? 'Ukryto' : 'Pokaż',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: state.isHidden ? AppColors.error : AppColors.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A widget that hides its child content when privacy mode is active.
class PrivacyValue extends StatelessWidget {
  final String value;
  final TextStyle? style;

  const PrivacyValue({super.key, required this.value, this.style});

  @override
  Widget build(BuildContext context) {
    final state = PrivacyToggle.of(context);
    return Text(
      state.conceal(value),
      style: style,
    );
  }
}
