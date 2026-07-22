import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../l10n/l10n.dart';

/// Sidebar navigation for the manager web CRM (MASTER_BUILD par.3.2).
/// Shown on Flutter Web for Zarzad/Administrator instead of the bottom bar.
/// Sections: Pulpit, Zgloszenia, Komunikaty, Mieszkancy, Osiedle, Kontakty,
/// Ustawienia/Profil.
class CrmSidebar extends StatelessWidget {
  const CrmSidebar({super.key, required this.selectedIndex, required this.onSelect});

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Extended rail with labels on wide desktop windows; icons-only otherwise.
    final extended = MediaQuery.of(context).size.width >= 1100;
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onSelect,
      extended: extended,
      labelType: extended
          ? NavigationRailLabelType.none
          : NavigationRailLabelType.all,
      backgroundColor: AppColors.lightCard,
      selectedIconTheme: const IconThemeData(color: AppColors.azure),
      selectedLabelTextStyle: const TextStyle(
        color: AppColors.azure,
        fontWeight: FontWeight.w700,
      ),
      unselectedIconTheme: const IconThemeData(
        color: AppColors.lightTextSecondary,
      ),
      unselectedLabelTextStyle: const TextStyle(
        color: AppColors.lightTextSecondary,
      ),
      destinations: [
        NavigationRailDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
          label: Text(l10n.navHome),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.edit_note_outlined),
          selectedIcon: const Icon(Icons.edit_note),
          label: Text(l10n.navReports),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.notifications_outlined),
          selectedIcon: const Icon(Icons.notifications),
          label: Text(l10n.navAnnouncements),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.how_to_vote_outlined),
          selectedIcon: const Icon(Icons.how_to_vote),
          label: Text(l10n.navResolutions),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.people_outline),
          selectedIcon: const Icon(Icons.people),
          label: Text(l10n.navResidents),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.apartment_outlined),
          selectedIcon: const Icon(Icons.apartment),
          label: Text(l10n.navEstate),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.contact_phone_outlined),
          selectedIcon: const Icon(Icons.contact_phone),
          label: Text(l10n.navContacts),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.person_outline),
          selectedIcon: const Icon(Icons.person),
          label: Text(l10n.navProfile),
        ),
      ],
    );
  }
}
