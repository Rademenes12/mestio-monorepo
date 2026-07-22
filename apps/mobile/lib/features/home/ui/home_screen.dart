import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/session/presentation/cubit/session_cubit.dart';
import '../../../core/di/injection.dart';
import '../../../l10n/l10n.dart';
import '../../auth/data/repositories/auth_repository.dart';
import '../../reports/presentation/cubit/reports_cubit.dart';
import '../../contacts/presentation/cubit/contacts_cubit.dart';
import '../../announcements/presentation/cubit/announcements_cubit.dart';
import '../../residents/presentation/cubit/residents_cubit.dart';
import '../../resolutions/presentation/cubit/resolutions_cubit.dart';
import '../../estate/presentation/cubit/estate_cubit.dart' as membership;
import '../../reports/presentation/ui/dashboard_screen.dart';
import '../../reports/presentation/ui/lock_screen.dart';
import '../../reports/presentation/ui/technician_portal_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ReportsCubit>(
          create: (_) => getIt<ReportsCubit>(),
        ),
        // EstateCubit removed from here (sesja 2 / C): it was firing
        // getEstateStructure() eagerly during registration/lock screen,
        // hanging on PostgREST. The cubit is now created lazily inside the
        // manager "Osiedle" tab (dashboard_screen._buildManagerEstateTab),
        // so it only runs when the user actually opens that tab.
        BlocProvider<ContactsCubit>(
          create: (_) => getIt<ContactsCubit>(),
        ),
        BlocProvider<AnnouncementsCubit>(
          create: (_) => getIt<AnnouncementsCubit>(),
        ),
        BlocProvider<ResidentsCubit>(
          create: (_) => getIt<ResidentsCubit>(),
        ),
        BlocProvider<ResolutionsCubit>(
          create: (_) => getIt<ResolutionsCubit>(),
        ),
        // Loads the user's estate memberships and drives per-estate scoping
        // (e.g. contacts). ContactsCubit subscribes to the same repository.
        // Eager so that active estate is selected before ReportsCubit needs it.
        BlocProvider<membership.EstateMembershipCubit>(
          lazy: false,
          create: (_) => getIt<membership.EstateMembershipCubit>(),
        ),
      ],
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsCubit, ReportsState>(
      builder: (context, state) {
        debugPrint(
          'ℹ️ [HomeScreen] building with ReportsState: ${state.runtimeType}',
        );
        return switch (state) {
          ReportsInitial() || ReportsLoading() => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          ReportsError(:final errorKey) => Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${context.l10n.errorLoadingData}: $errorKey'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<ReportsCubit>().retry(),
                    child: Text(context.l10n.retryButton),
                  ),
                ],
              ),
            ),
          ),
          ReportsLoaded(:final profile) =>
            profile == null || !profile.isVerified
                ? LockScreen(
                    initialEmail: context
                        .watch<SessionCubit>()
                        .state
                        .emailOrNull,
                  )
                : profile.role == 'Serwisant'
                ? const TechnicianPortalScreen()
                : DashboardScreen(
                    onLogout: () => getIt<AuthRepository>().signOut(),
                  ),
        };
      },
    );
  }
}
