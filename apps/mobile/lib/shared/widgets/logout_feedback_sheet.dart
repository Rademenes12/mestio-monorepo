import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/l10n.dart';

/// Displays a bottom sheet asking the user for their opinion before logging out.
///
/// It provides options to redirect to the Google Play Store or Apple App Store
/// to leave a review, or to proceed directly with the logout.
Future<void> showLogoutFeedbackSheet({
  required BuildContext context,
  required VoidCallback onConfirmLogout,
}) async {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final l10n = context.l10n;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: 24,
            top: 8,
          ),
          child: Stack(
            children: [
              // Close button on top-right corner
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                  onPressed: () => Navigator.pop(sheetContext),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  // Pink Heart Image
                  Image.asset(
                    'assets/images/heart.png',
                    height: 110,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback icon if the image cannot be loaded
                      return Icon(
                        Icons.favorite,
                        color: Colors.pinkAccent[200],
                        size: 90,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  // Title
                  Text(
                    l10n.logoutFeedbackTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: isDark ? AppColors.darkTextPrimary : const Color(0xFF132F5C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Description
                  Text(
                    l10n.logoutFeedbackDescription,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.darkTextSecondary : const Color(0xFF636375),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // "Zostaw opinię" Button
                  ElevatedButton(
                    onPressed: () async {
                      final url = Platform.isAndroid
                          ? 'https://play.google.com/store/apps/details?id=com.pawelpasik.mestio'
                          : 'https://apps.apple.com/app/id6470000000';
                      final uri = Uri.parse(url);
                      try {
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        } else {
                          debugPrint('Could not launch store URL: $url');
                        }
                      } catch (e) {
                        debugPrint('Error launching store URL: $e');
                      }
                      if (sheetContext.mounted) {
                        Navigator.pop(sheetContext);
                      }
                      onConfirmLogout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D52D6),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppColors.radiusButton),
                      ),
                    ),
                    child: Text(
                      l10n.logoutFeedbackRateButton,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // "Wyloguj" Button
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      onConfirmLogout();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark ? AppColors.darkTextPrimary : const Color(0xFF0D52D6),
                      side: BorderSide(
                        color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                        width: 1.5,
                      ),
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppColors.radiusButton),
                      ),
                    ),
                    child: Text(
                      l10n.logoutFeedbackLogoutButton,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
