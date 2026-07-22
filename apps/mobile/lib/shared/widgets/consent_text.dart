import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/l10n.dart';

/// Consent text with clickable Privacy Policy / Terms of Service links.
class ConsentText extends StatefulWidget {
  const ConsentText({super.key, required this.isDark, required this.l10n});

  final bool isDark;
  final AppLocalizations l10n;

  @override
  State<ConsentText> createState() => _ConsentTextState();
}

class _ConsentTextState extends State<ConsentText> {
  static const _privacyPolicyUrl = 'https://mestio.pl/privacy-policy';
  static const _termsOfServiceUrl = 'https://mestio.pl/terms-of-service';

  late final _privacyRecognizer = TapGestureRecognizer()
    ..onTap = () => _openUrl(_privacyPolicyUrl);
  late final _termsRecognizer = TapGestureRecognizer()
    ..onTap = () => _openUrl(_termsOfServiceUrl);

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void dispose() {
    _privacyRecognizer.dispose();
    _termsRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = TextStyle(
      fontSize: 12,
      color: widget.isDark ? Colors.grey.shade400 : const Color(0xFF636375),
    );
    final linkStyle = baseStyle.copyWith(
      color: AppColors.electricIndigo,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.underline,
    );
    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: '${widget.l10n.registerConsentLabel} '),
          TextSpan(
            text: widget.l10n.privacyPolicyButton,
            style: linkStyle,
            recognizer: _privacyRecognizer,
          ),
          const TextSpan(text: ' · '),
          TextSpan(
            text: widget.l10n.termsOfServiceButton,
            style: linkStyle,
            recognizer: _termsRecognizer,
          ),
        ],
      ),
    );
  }
}
