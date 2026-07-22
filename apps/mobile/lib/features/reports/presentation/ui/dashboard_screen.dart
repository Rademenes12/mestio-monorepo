import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../profiles/models/resident_profile_model.dart';
import '../../models/building_model.dart';
import '../cubit/reports_cubit.dart';
import '../cubit/estate_cubit.dart';
import '../../../estate/presentation/cubit/estate_cubit.dart' as membership;
import 'qr_scan_screen.dart';
import '../../../estate/models/estate_model.dart';
import '../../../contacts/presentation/ui/contacts_tab.dart';
import '../../../contacts/presentation/cubit/contacts_cubit.dart';
import '../../../residents/presentation/ui/residents_tab.dart';
import '../../../resolutions/presentation/ui/resolutions_tab.dart';
import '../../../../app/profile/presentation/ui/delete_account_confirmation_screen.dart';
import '../../services/location_service.dart';
import '../../../../app/session/presentation/cubit/session_cubit.dart';
import 'tabs/resident_home_tab.dart';
import 'tabs/manager_home_tab.dart';
import 'tabs/security_dashboard_tab.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/role_display.dart';
import '../../../../shared/error_messages.dart';
import '../../../../shared/widgets/logout_feedback_sheet.dart';
import 'widgets/locked_tab_placeholder.dart';
import 'widgets/estate_switcher_app_bar.dart';
import 'widgets/resident_reports_tab.dart';
import 'widgets/speed_dial_fab.dart';
import 'widgets/feedback_sheet.dart';
import 'widgets/manager_reports_tab.dart';
import 'widgets/manager_announcements_tab.dart';
import 'widgets/add_report_bottom_sheet.dart';
import 'widgets/manager_estate_tab.dart';
import 'widgets/crm_sidebar.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const DashboardScreen({super.key, required this.onLogout});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentTabIndex = 0;
  bool _isFetchingGPS = false;
  double? _reportLatitude;
  double? _reportLongitude;
  String? _gpsSource;
  String? _gpsLabel;

  // Announcements are now loaded server-side from `fixflow_announcements`
  // via AnnouncementsCubit (sesja 5). The in-memory mock list was removed.

  @override
  void initState() {
    super.initState();
    _refreshGPS(init: true);
  }

  Future<void> _refreshGPS({bool init = false}) async {
    if (!mounted) return;
    setState(() {
      _isFetchingGPS = true;
    });
    try {
      final loc = await context.read<LocationService>().getCurrentLocation();
      if (!mounted) return;
      setState(() {
        _reportLatitude = loc.latitude;
        _reportLongitude = loc.longitude;
        _gpsSource = loc.source;
        _gpsLabel = loc.label;
        _isFetchingGPS = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isFetchingGPS = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(
      scaffoldBackgroundColor: AppColors.lightCanvas,
      primaryColor: AppColors.electricIndigo,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.electricIndigo,
        primary: AppColors.electricIndigo,
        surface: AppColors.lightCard,
      ),
    );

    return Theme(
      data: theme,
      child: BlocBuilder<SessionCubit, SessionState>(
        builder: (context, sessionState) {
          final isPro = sessionState.isProUser;

          return BlocBuilder<ReportsCubit, ReportsState>(
            builder: (context, state) {
              if (state is ReportsError) {
                return Scaffold(
                  body: SafeArea(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppColors.spacingMd),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SelectableText(
                              messageForErrorKey(context.l10n, state.errorKey),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: AppColors.spacingMd),
                            ElevatedButton(
                              onPressed: () =>
                                  context.read<ReportsCubit>().retry(),
                              child: Text(context.l10n.retryButtonLabel),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }

              if (state is! ReportsLoaded) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              final rawReports = state.reports;
              final profile = state.profile;
              final role = profile?.role ?? 'Mieszkaniec';

              final isManager = role == 'Zarząd' || role == 'Administrator';
              final isSecurity = role == 'Ochrona';

              final reports = switch (role) {
                'Mieszkaniec' => rawReports.where((r) {
                  final emailToCheck = profile?.email ?? '';
                  final sessionEmail =
                      context.read<ReportsCubit>().currentUserEmail ?? '';
                  final effectiveEmail = emailToCheck.isNotEmpty
                      ? emailToCheck
                      : sessionEmail;
                  if (effectiveEmail.isEmpty) return false;
                  return r.reporterEmail.toLowerCase() ==
                      effectiveEmail.toLowerCase();
                }).toList(),
                'Ochrona' => rawReports.where((r) {
                  final emailToCheck = profile?.email ?? '';
                  final sessionEmail =
                      context.read<ReportsCubit>().currentUserEmail ?? '';
                  final effectiveEmail = emailToCheck.isNotEmpty
                      ? emailToCheck
                      : sessionEmail;
                  if (effectiveEmail.isEmpty) return true;
                  return r.reporterEmail.toLowerCase() ==
                      effectiveEmail.toLowerCase();
                }).toList(),
                _ => rawReports,
              };

              // MASTER_BUILD par.3: full management tooling lives in the web
              // CRM (panel); the mobile app keeps a light manager view with
              // 4 tabs only (Pulpit/Zgloszenia/Kontakty/Profil).
              final bool isWebCrm = kIsWeb && isManager;

              final List<Widget> tabs;
              if (isWebCrm) {
                tabs = [
                  ManagerHomeTab(
                    reports: reports,
                    role: role,
                    userName: profile?.name ?? 'Zarządca',
                  ),
                  ManagerReportsTabWidget(reports: reports, role: role),
                  isPro
                      ? const ManagerAnnouncementsTab()
                      : const LockedTabPlaceholder(featureType: 'komunikator'),
                  const ResolutionsTab(canManage: true),
                  ResidentsTab(),
                  ManagerEstateTab(
                    onAddResidentialBuilding: _showAddBuildingDialog,
                    onAddGarageBuilding: _showAddGarageBuildingDialog,
                    onEditBuilding: _showEditBuildingDialog,
                    onDeleteBuilding: _confirmDeleteBuilding,
                    onAddStairwell: _showAddStairwellDialog,
                    onEditStairwell: _showEditStairwellDialog,
                    onDeleteStairwell: _confirmDeleteStairwell,
                  ),
                  const ContactsTab(isAdmin: true),
                  _profileTabView(profile, theme),
                ];
              } else if (isManager) {
                tabs = [
                  ManagerHomeTab(
                    reports: reports,
                    role: role,
                    userName: profile?.name ?? 'Zarządca',
                  ),
                  ManagerReportsTabWidget(reports: reports, role: role),
                  isPro
                      ? const ManagerAnnouncementsTab()
                      : const LockedTabPlaceholder(featureType: 'komunikator'),
                  ResidentsTab(),
                  ManagerEstateTab(
                    onAddResidentialBuilding: _showAddBuildingDialog,
                    onAddGarageBuilding: _showAddGarageBuildingDialog,
                    onEditBuilding: _showEditBuildingDialog,
                    onDeleteBuilding: _confirmDeleteBuilding,
                    onAddStairwell: _showAddStairwellDialog,
                    onEditStairwell: _showEditStairwellDialog,
                    onDeleteStairwell: _confirmDeleteStairwell,
                  ),
                  const ContactsTab(isAdmin: true),
                  const ResolutionsTab(canManage: true),
                  _profileTabView(profile, theme),
                ];
              } else if (isSecurity) {
                tabs = [
                  SecurityDashboardTab(
                    securityReports: reports,
                    onReportToManager: () =>
                        _showAddReportBottomSheet(context, theme),
                    onTriggerEmergency: () =>
                        _showAddReportBottomSheet(context, theme),
                  ),
                  ResidentReportsTab(reports: reports),
                  ContactsTab(isAdmin: false),
                  _profileTabView(profile, theme),
                ];
              } else {
                tabs = [
                  ResidentHomeTab(
                    reports: reports,
                    profile: profile,
                    onNavigateToReports: () =>
                        setState(() => _currentTabIndex = 1),
                    // Profile is the 5th tab (after Uchwały) for residents.
                    onNavigateToProfile: () =>
                        setState(() => _currentTabIndex = 4),
                  ),
                  ResidentReportsTab(reports: reports),
                  ContactsTab(isAdmin: false),
                  const ResolutionsTab(),
                  _profileTabView(profile, theme),
                ];
              }

              final l10nNav = context.l10n;
              final homeNavItem = BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined, size: 26),
                activeIcon: const Icon(Icons.home, size: 26),
                label: l10nNav.navHome,
              );
              final reportsNavItem = BottomNavigationBarItem(
                icon: const Icon(Icons.edit_note_outlined, size: 26),
                activeIcon: const Icon(Icons.edit_note, size: 26),
                label: l10nNav.navReports,
              );
              final phonesNavItem = BottomNavigationBarItem(
                icon: const Icon(Icons.phone_outlined, size: 26),
                activeIcon: const Icon(Icons.phone, size: 26),
                label: l10nNav.navPhones,
              );
              final resolutionsNavItem = BottomNavigationBarItem(
                icon: const Icon(Icons.how_to_vote_outlined, size: 26),
                activeIcon: const Icon(Icons.how_to_vote, size: 26),
                label: l10nNav.navResolutions,
              );
              final profileNavItem = BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline, size: 26),
                activeIcon: const Icon(Icons.person, size: 26),
                label: l10nNav.navProfile,
              );
              // Uchwały (voting) is for residents and the office; security
              // keeps the 4-tab layout (prototype parity).
              final List<BottomNavigationBarItem> navItems = isManager
                  ? [
                      homeNavItem,
                      reportsNavItem,
                      BottomNavigationBarItem(
                        icon: const Icon(
                          Icons.campaign_outlined,
                          size: 26,
                        ),
                        activeIcon: const Icon(Icons.campaign, size: 26),
                        label: l10nNav.navAnnouncements,
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(
                          Icons.people_outline,
                          size: 26,
                        ),
                        activeIcon: const Icon(Icons.people, size: 26),
                        label: l10nNav.navResidents,
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(
                          Icons.apartment_outlined,
                          size: 26,
                        ),
                        activeIcon: const Icon(Icons.apartment, size: 26),
                        label: l10nNav.navEstate,
                      ),
                      resolutionsNavItem,
                      profileNavItem,
                    ]
                  : isSecurity
                  ? [homeNavItem, reportsNavItem, phonesNavItem, profileNavItem]
                  : [
                      homeNavItem,
                      reportsNavItem,
                      phonesNavItem,
                      resolutionsNavItem,
                      profileNavItem,
                    ];

              final mState = context
                  .watch<membership.EstateMembershipCubit>()
                  .state;
              final estates = mState is membership.EstateLoaded
                  ? mState.estates
                  : <Estate>[];
              final activeEstate = mState is membership.EstateLoaded
                  ? mState.activeEstate
                  : null;
              final bool hasEstates = estates.isNotEmpty;
              final reportsErrorKey = state.errorKey;

              return Scaffold(
                backgroundColor: AppColors.paper,
                appBar: hasEstates
                    ? EstateSwitcherAppBar(
                        estates: estates,
                        active: activeEstate,
                        reports: reports,
                      )
                    : null,
                body: SafeArea(
                  child: Builder(
                    builder: (context) {
                      final content = Column(
                        children: [
                          if (reportsErrorKey != null)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(
                                AppColors.spacingSm,
                              ),
                              margin: const EdgeInsets.all(AppColors.spacingSm),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(
                                  AppColors.radiusCard,
                                ),
                                border: Border.all(
                                  color: Colors.red.withValues(alpha: 0.3),
                                ),
                              ),
                              child: SelectableText(
                                messageForErrorKey(
                                  context.l10n,
                                  reportsErrorKey,
                                ),
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          Expanded(
                            child:
                                tabs[_currentTabIndex.clamp(
                                  0,
                                  tabs.length - 1,
                                )],
                          ),
                        ],
                      );
                      if (!isWebCrm) return content;
                      return Row(
                        children: [
                          CrmSidebar(
                            selectedIndex: _currentTabIndex.clamp(
                              0,
                              tabs.length - 1,
                            ),
                            onSelect: (i) =>
                                setState(() => _currentTabIndex = i),
                          ),
                          const VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: AppColors.cardBorder,
                          ),
                          Expanded(child: content),
                        ],
                      );
                    },
                  ),
                ),
                floatingActionButton:
                    (_currentTabIndex == 0 || _currentTabIndex == 1)
                    ? SpeedDialFab(
                        onReportIssue: activeEstate == null
                            ? null
                            : () => _showAddReportBottomSheet(context, theme),
                        onScanQr: activeEstate == null
                            ? null
                            : () => _onScanQr(context),
                        onMessageToBoard: activeEstate == null
                            ? null
                            : () => _showAddReportBottomSheet(context, theme),
                        noEstateMessage: l10nNav.errorNoEstate,
                      )
                    : null,
                bottomNavigationBar: isWebCrm
                    ? null
                    : Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: AppColors.cardBorder,
                              width: 1,
                            ),
                          ),
                        ),
                        child: BottomNavigationBar(
                          currentIndex: _currentTabIndex.clamp(
                            0,
                            tabs.length - 1,
                          ),
                          type: BottomNavigationBarType.fixed,
                          selectedItemColor: AppColors.azure,
                          unselectedItemColor: AppColors.lightTextSecondary,
                          backgroundColor: AppColors.lightCard,
                          elevation: 0,
                          selectedFontSize: 11,
                          unselectedFontSize: 11,
                          items: navItems,
                          onTap: (index) {
                            setState(() {
                              _currentTabIndex = index;
                            });
                          },
                        ),
                      ),
              );
            },
          );
        },
      ),
    );
  }

  // ===========================================================================
  // FORMULARZ (BOTTOM SHEET)
  // ===========================================================================

  void _showAddReportBottomSheet(BuildContext context, ThemeData theme) {
    // Capture cubit + messenger + l10n strings from the screen context, because
    // the bottom sheet is a new route and its inner BuildContext doesn't see
    // the BlocProvider<ReportsCubit> declared above HomeScreen. We also
    // capture l10n strings up-front so the async submit callback doesn't
    // depend on a potentially-disposed context.
    final reportsCubit = context.read<ReportsCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final reportAddedMsg = context.l10n.reportAddedSnackbar;
    // Resolve role-aware index of the "Zgłoszenia" tab. For Mieszkaniec the
    // reports list lives at tab index 1; managers don't have a dedicated
    // reports tab here, so we only auto-navigate for residents.
    final reportsState = reportsCubit.state;
    final isResident =
        reportsState is ReportsLoaded &&
        (reportsState.profile?.role ?? 'Mieszkaniec') == 'Mieszkaniec';
    final userRole = reportsState is ReportsLoaded
        ? (reportsState.profile?.role ?? 'Mieszkaniec')
        : 'Mieszkaniec';

    final mediaQuery = MediaQuery.of(context);
    final sheetMaxHeight = mediaQuery.size.height * 0.92;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(maxHeight: sheetMaxHeight),
      builder: (sheetContext) {
        return AddReportBottomSheetContent(
          userRole: userRole,
          onReportSubmitted:
              (
                title,
                description,
                category,
                photoPaths,
                pdfPath,
                additionalInfo,
                isPriority,
              ) async {
                await reportsCubit.addReport(
                  title: title,
                  description: description,
                  category: category,
                  photoPath: photoPaths.isNotEmpty ? photoPaths.first : null,
                  extraPhotoPaths: photoPaths.length > 1
                      ? photoPaths.sublist(1)
                      : null,
                  pdfPath: pdfPath,
                  latitude: _reportLatitude,
                  longitude: _reportLongitude,
                  additionalInfo: additionalInfo,
                  isPriority: isPriority,
                );

                final currentState = reportsCubit.state;
                final hasError =
                    currentState is ReportsLoaded &&
                    currentState.errorKey != null;
                if (hasError) {
                  // Error is already shown inline on the dashboard banner.
                  return;
                }

                messenger.showSnackBar(
                  SnackBar(
                    content: Text(reportAddedMsg),
                    backgroundColor: AppColors.neonMint,
                  ),
                );
                // After a successful submit, take the resident to the reports tab
                // so they immediately see the new entry (sesja 2 feedback B).
                if (isResident && mounted) {
                  setState(() => _currentTabIndex = 1);
                }
              },
        );
      },
    );
  }

  Future<void> _onScanQr(BuildContext context) async {
    final reportsCubit = context.read<ReportsCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final reportAddedMsg = context.l10n.reportAddedSnackbar;
    final reportsState = reportsCubit.state;
    final isResident =
        reportsState is ReportsLoaded &&
        (reportsState.profile?.role ?? 'Mieszkaniec') == 'Mieszkaniec';
    final userRole = reportsState is ReportsLoaded
        ? (reportsState.profile?.role ?? 'Mieszkaniec')
        : 'Mieszkaniec';

    final prefill = await Navigator.of(context).push<Map<String, String?>?>(
      MaterialPageRoute(builder: (_) => const QrScanScreen()),
    );

    if (!context.mounted) return;
    if (prefill != null) {
      final mediaQuery = MediaQuery.of(context);
      final sheetMaxHeight = mediaQuery.size.height * 0.92;

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        constraints: BoxConstraints(maxHeight: sheetMaxHeight),
        builder: (sheetContext) {
          return AddReportBottomSheetContent(
            userRole: userRole,
            prefillData: prefill,
            onReportSubmitted:
                (
                  title,
                  description,
                  category,
                  photoPaths,
                  pdfPath,
                  additionalInfo,
                  isPriority,
                ) async {
                  await reportsCubit.addReport(
                    title: title,
                    description: description,
                    category: category,
                    photoPath: photoPaths.isNotEmpty ? photoPaths.first : null,
                    extraPhotoPaths: photoPaths.length > 1
                        ? photoPaths.sublist(1)
                        : null,
                    pdfPath: pdfPath,
                    latitude: _reportLatitude,
                    longitude: _reportLongitude,
                    additionalInfo: additionalInfo,
                    isPriority: isPriority,
                  );
                  if (!sheetContext.mounted) return;
                  Navigator.of(sheetContext).pop();
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(reportAddedMsg),
                      backgroundColor: AppColors.mint,
                    ),
                  );
                  if (isResident && mounted) {
                    setState(() => _currentTabIndex = 1);
                  }
                },
          );
        },
      );
    }
  }

  // ===========================================================================
  // PROFIL I USTAWIENIA TAB (Wspólny)
  // ===========================================================================

  Widget _profileTabView(ResidentProfileModel? profile, ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(AppColors.spacingSm),
      children: [
        Text(
          context.l10n.profileUserTitle,
          style: const TextStyle(
            color: AppColors.lightTextPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppColors.spacingMd),

        // User Details Card
        Card(
          color: AppColors.lightCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppColors.radiusCard),
            side: const BorderSide(color: AppColors.lightBorder),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.electricIndigo.withValues(
                        alpha: 0.1,
                      ),
                      child: Text(
                        profile?.name.isNotEmpty == true
                            ? profile!.name[0].toUpperCase()
                            : '👤',
                        style: const TextStyle(
                          color: AppColors.electricIndigo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile?.name ?? 'Nazwa Lokatora',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            profile?.email ?? 'email@wspolnota.pl',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Text(
                  context.l10n.addressLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  context.l10n.roleLabel(
                    roleDisplayLabel(profile?.role ?? 'Mieszkaniec'),
                  ),
                ),
                // The profile values already include their type label (e.g.
                // "Budynek 1", "Klatka A", "Piętro 3", "Mieszkanie 1"), so we
                // render them verbatim to avoid duplicating the labels
                // ("Budynek Budynek 1 · Kładka Kładka A …").
                Text(
                  '${profile?.building ?? "-"} · ${profile?.footbridge ?? "-"} · ${profile?.floor ?? "-"} · ${profile?.apartment ?? "-"}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppColors.spacingSm),

        // GPS Card (MOVED HERE)
        Card(
          color: AppColors.lightCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppColors.radiusCard),
            side: const BorderSide(color: AppColors.lightBorder),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppColors.electricIndigo,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          context.l10n.gpsDevicePositionLabel,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.refresh,
                        size: 20,
                        color: AppColors.electricIndigo,
                      ),
                      onPressed: () => _refreshGPS(),
                    ),
                  ],
                ),
                if (_isFetchingGPS)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: LinearProgressIndicator(),
                  )
                else ...[
                  Text(
                    context.l10n.gpsLatitudeLabel(_reportLatitude?.toStringAsFixed(6) ?? '52.229675'),
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    context.l10n.gpsLongitudeLabel(_reportLongitude?.toStringAsFixed(6) ?? '21.012229'),
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    context.l10n.gpsSourceLabel(_gpsSource ?? 'Warszawa'),
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                  Text(
                    context.l10n.gpsLabelLabel(_gpsLabel ?? 'Domyślna (Warszawa)'),
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: AppColors.spacingSm),

        // Emergency Contacts section for Zarządca/Administrator (Phase 3 A choice)
        if (profile?.role == 'Zarząd' || profile?.role == 'Administrator') ...[
          Card(
            color: AppColors.lightCard,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppColors.radiusCard),
              side: const BorderSide(color: AppColors.lightBorder),
            ),
            child: ListTile(
              leading: const Icon(Icons.phone, color: AppColors.azure),
              title: Text(
                context.l10n.contactBookCardTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                context.l10n.contactBookCardSubtitle,
                style: const TextStyle(fontSize: 12),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                final contactsCubit = context.read<ContactsCubit>();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(title: Text(context.l10n.contactBookTitle)),
                      body: BlocProvider<ContactsCubit>.value(
                        value: contactsCubit,
                        child: const ContactsTab(isAdmin: true),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppColors.spacingSm),
        ],

        // Kontakt / wsparcie: opens a feedback sheet (Błąd/Pomysł/Pytanie +
        // message) that sends through the user's mail client — there is no
        // in-app feedback backend, so mailto: is still the delivery
        // mechanism, just composed from the structured modal below.
        Card(
          color: AppColors.lightCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppColors.radiusCard),
            side: const BorderSide(color: AppColors.lightBorder),
          ),
          child: ListTile(
            leading: const Icon(
              Icons.mail_outline,
              color: AppColors.electricIndigo,
            ),
            title: Text(
              context.l10n.supportContactTitle,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: const Text(
              'aivolux@gmail.com',
              style: TextStyle(color: AppColors.electricIndigo),
            ),
            trailing: const Icon(Icons.open_in_new, size: 18),
            onTap: () => _showFeedbackSheet(context, profile),
          ),
        ),
        const SizedBox(height: AppColors.spacingMd),

        // Danger zone — account deletion
        Card(
          color: AppColors.lightCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppColors.radiusCard),
            side: const BorderSide(color: AppColors.lightBorder),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.deleteAccountSectionTitle,
                  style: const TextStyle(
                    color: AppColors.crimsonCoral,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.deleteAccountPermanentWarning,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).push<void>(
                      MaterialPageRoute<void>(
                        builder: (_) => const DeleteAccountConfirmationScreen(),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.crimsonCoral,
                      side: const BorderSide(color: AppColors.crimsonCoral),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(context.l10n.deleteAccountButtonLabel),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppColors.spacingMd),

        // Logout
        ElevatedButton.icon(
          onPressed: () => showLogoutFeedbackSheet(
            context: context,
            onConfirmLogout: widget.onLogout,
          ),
          icon: const Icon(Icons.exit_to_app),
          label: Text(context.l10n.logoutButtonLabel),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.crimsonCoral,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppColors.radiusButton),
            ),
          ),
        ),
      ],
    );
  }


  void _showAddBuildingDialog(BuildContext context) {
    final l10n = context.l10n;
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    String buildingType = 'residential';

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.addBuildingDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: l10n.buildingNameLabel,
                  hintText: l10n.buildingNameHint,
                  border: const OutlineInputBorder(),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: buildingType,
                decoration: InputDecoration(
                  labelText: l10n.buildingTypeLabel,
                  border: const OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'residential',
                    child: Text(l10n.buildingTypeResidential),
                  ),
                  DropdownMenuItem(value: 'garage', child: Text(l10n.buildingTypeGarage)),
                ],
                onChanged: (v) => setDialogState(() => buildingType = v!),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: l10n.buildingAddressLabel,
                  hintText: l10n.buildingAddressHint,
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.cancelButton),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isEmpty) return;
                context.read<EstateCubit>().addBuilding(
                  name,
                  addressController.text.trim().isEmpty
                      ? null
                      : addressController.text.trim(),
                  buildingType: buildingType,
                );
                Navigator.pop(dialogContext);
              },
              child: Text(l10n.addButton),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddGarageBuildingDialog(BuildContext context) {
    final l10n = context.l10n;
    final nameController = TextEditingController(text: l10n.garageNameHint);
    final addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.addGarageDialogTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: l10n.garageNameLabel,
                hintText: l10n.garageNameHint,
                border: const OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: l10n.buildingAddressLabel,
                hintText: l10n.buildingAddressHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.garageFloorInfo,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancelButton),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isEmpty) return;
              context.read<EstateCubit>().addBuilding(
                name,
                addressController.text.trim().isEmpty
                    ? null
                    : addressController.text.trim(),
                buildingType: 'garage',
              );
              Navigator.pop(dialogContext);
            },
            child: Text(l10n.addButton),
          ),
        ],
      ),
    );
  }

  void _showEditBuildingDialog(BuildContext context, BuildingModel building) {
    final l10n = context.l10n;
    final nameController = TextEditingController(text: building.name);
    final addressController = TextEditingController(
      text: building.address ?? '',
    );
    String buildingType = building.buildingType;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.editBuildingDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: l10n.buildingNameLabel,
                  border: const OutlineInputBorder(),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: buildingType,
                decoration: InputDecoration(
                  labelText: l10n.buildingTypeLabel,
                  border: const OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'residential',
                    child: Text(l10n.buildingTypeResidential),
                  ),
                  DropdownMenuItem(value: 'garage', child: Text(l10n.buildingTypeGarage)),
                ],
                onChanged: (v) => setDialogState(() => buildingType = v!),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: l10n.buildingAddressLabel,
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.cancelButton),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isEmpty) return;
                context.read<EstateCubit>().updateBuilding(
                  building.copyWith(
                    name: name,
                    buildingType: buildingType,
                    address: addressController.text.trim().isEmpty
                        ? null
                        : addressController.text.trim(),
                  ),
                );
                Navigator.pop(dialogContext);
              },
              child: Text(l10n.saveButton),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteBuilding(BuildContext context, BuildingModel building) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteBuildingDialogTitle),
        content: Text(l10n.deleteBuildingDialogContent(building.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancelButton),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<EstateCubit>().deleteBuilding(building.id);
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.deleteButton),
          ),
        ],
      ),
    );
  }

  void _showAddStairwellDialog(BuildContext context, String buildingId) {
    final l10n = context.l10n;
    final letters = List.generate(
      26,
      (i) => String.fromCharCode('A'.codeUnitAt(0) + i),
    );
    String selectedName = 'A';
    int floorMin = 0;
    int floorMax = 4;
    String? garageEntranceLabel;
    String? validationError;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final showGarageEntrance = floorMin < 0;
          return AlertDialog(
            title: Text(l10n.addStairwellDialogTitle),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: selectedName,
                    decoration: InputDecoration(
                      labelText: l10n.stairwellNameLabel,
                      border: const OutlineInputBorder(),
                    ),
                    items: letters
                        .map(
                          (l) => DropdownMenuItem(
                            value: l,
                            child: Text(l10n.stairwellNameValue(l)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setDialogState(() => selectedName = value!),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          initialValue: floorMin,
                          decoration: InputDecoration(
                            labelText: l10n.floorMinLabel,
                            border: const OutlineInputBorder(),
                          ),
                          items: [
                            for (var f = -6; f <= 20; f++)
                              DropdownMenuItem(value: f, child: Text('$f')),
                          ],
                          onChanged: (value) => setDialogState(() {
                            floorMin = value!;
                            if (floorMin > floorMax) floorMax = floorMin;
                            validationError = null;
                            if (!showGarageEntrance) garageEntranceLabel = null;
                          }),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          initialValue: floorMax,
                          decoration: InputDecoration(
                            labelText: l10n.floorMaxLabel,
                            border: const OutlineInputBorder(),
                          ),
                          items: [
                            for (var f = -6; f <= 20; f++)
                              DropdownMenuItem(value: f, child: Text('$f')),
                          ],
                          onChanged: (value) => setDialogState(() {
                            floorMax = value!;
                            validationError = null;
                          }),
                        ),
                      ),
                    ],
                  ),
                  if (showGarageEntrance) ...[
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String?>(
                      initialValue: garageEntranceLabel,
                      decoration: InputDecoration(
                        labelText: l10n.garageEntranceLabel,
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: null,
                          child: Text(l10n.notApplicableLabel),
                        ),
                        ...letters.map(
                          (l) => DropdownMenuItem(
                            value: l,
                            child: Text(l10n.garageEntranceValue(l)),
                          ),
                        ),
                      ],
                      onChanged: (value) =>
                          setDialogState(() => garageEntranceLabel = value),
                    ),
                  ],
                  if (validationError != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      validationError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(l10n.cancelButton),
              ),
              ElevatedButton(
                onPressed: () {
                  if (floorMax < floorMin) {
                    setDialogState(
                      () => validationError = l10n.validationFloorRangeInvalid,
                    );
                    return;
                  }
                  context.read<EstateCubit>().addStairwell(
                    buildingId,
                    name: selectedName,
                    floorMin: floorMin,
                    floorMax: floorMax,
                    garageEntranceLabel: garageEntranceLabel,
                  );
                  Navigator.pop(dialogContext);
                },
                child: Text(l10n.addButton),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEditStairwellDialog(
    BuildContext context,
    StairwellModel stairwell,
  ) {
    final l10n = context.l10n;
    final letters = List.generate(
      26,
      (i) => String.fromCharCode('A'.codeUnitAt(0) + i),
    );
    String selectedName = stairwell.name;
    int floorMin = stairwell.floorMin;
    int floorMax = stairwell.floorMax;
    String? garageEntranceLabel = stairwell.garageEntranceLabel;
    String? validationError;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final showGarageEntrance = floorMin < 0;
          return AlertDialog(
            title: Text(l10n.editStairwellDialogTitle),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: selectedName,
                    decoration: InputDecoration(
                      labelText: l10n.stairwellNameLabel,
                      border: const OutlineInputBorder(),
                    ),
                    items: letters
                        .map(
                          (l) => DropdownMenuItem(
                            value: l,
                            child: Text(l10n.stairwellNameValue(l)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setDialogState(() => selectedName = value!),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          initialValue: floorMin,
                          decoration: InputDecoration(
                            labelText: l10n.floorMinLabel,
                            border: const OutlineInputBorder(),
                          ),
                          items: [
                            for (var f = -6; f <= 20; f++)
                              DropdownMenuItem(value: f, child: Text('$f')),
                          ],
                          onChanged: (value) => setDialogState(() {
                            floorMin = value!;
                            if (floorMin > floorMax) floorMax = floorMin;
                            validationError = null;
                            if (!showGarageEntrance) garageEntranceLabel = null;
                          }),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          initialValue: floorMax,
                          decoration: InputDecoration(
                            labelText: l10n.floorMaxLabel,
                            border: const OutlineInputBorder(),
                          ),
                          items: [
                            for (var f = -6; f <= 20; f++)
                              DropdownMenuItem(value: f, child: Text('$f')),
                          ],
                          onChanged: (value) => setDialogState(() {
                            floorMax = value!;
                            validationError = null;
                          }),
                        ),
                      ),
                    ],
                  ),
                  if (showGarageEntrance) ...[
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String?>(
                      initialValue: garageEntranceLabel,
                      decoration: InputDecoration(
                        labelText: l10n.garageEntranceLabel,
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: null,
                          child: Text(l10n.notApplicableLabel),
                        ),
                        ...letters.map(
                          (l) => DropdownMenuItem(
                            value: l,
                            child: Text(l10n.garageEntranceValue(l)),
                          ),
                        ),
                      ],
                      onChanged: (value) =>
                          setDialogState(() => garageEntranceLabel = value),
                    ),
                  ],
                  if (validationError != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      validationError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(l10n.cancelButton),
              ),
              ElevatedButton(
                onPressed: () {
                  if (floorMax < floorMin) {
                    setDialogState(
                      () => validationError = l10n.validationFloorRangeInvalid,
                    );
                    return;
                  }
                  context.read<EstateCubit>().updateStairwell(
                    stairwell.copyWith(
                      name: selectedName,
                      floorMin: floorMin,
                      floorMax: floorMax,
                      garageEntranceLabel: garageEntranceLabel,
                    ),
                  );
                  Navigator.pop(dialogContext);
                },
                child: Text(l10n.saveButton),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmDeleteStairwell(BuildContext context, StairwellModel stairwell) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteStairwellDialogTitle),
        content: Text(l10n.deleteStairwellDialogContent(stairwell.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancelButton),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<EstateCubit>().deleteStairwell(stairwell.id);
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.deleteButton),
          ),
        ],
      ),
    );
  }
}

void _showFeedbackSheet(BuildContext context, ResidentProfileModel? profile) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => FeedbackSheet(profile: profile),
  );
}
