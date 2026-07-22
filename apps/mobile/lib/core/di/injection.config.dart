// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as _i161;
import 'package:mestio/app/locale/data/datasources/app_locale_data_source.dart'
    as _i1053;
import 'package:mestio/app/locale/data/repositories/app_locale_repository.dart'
    as _i1044;
import 'package:mestio/app/locale/presentation/cubit/app_locale_cubit.dart'
    as _i731;
import 'package:mestio/app/paywall/presentation/paywall_presenter.dart'
    as _i1051;
import 'package:mestio/app/profile/presentation/cubit/account_actions_cubit.dart'
    as _i407;
import 'package:mestio/app/profile/presentation/cubit/data_export_cubit.dart'
    as _i427;
import 'package:mestio/app/profile/presentation/cubit/delete_account_preflight_cubit.dart'
    as _i973;
import 'package:mestio/app/review/presentation/review_presenter.dart' as _i520;
import 'package:mestio/app/session/data/repositories/session_repository.dart'
    as _i345;
import 'package:mestio/app/session/presentation/cubit/session_cubit.dart'
    as _i850;
import 'package:mestio/core/di/app_module.dart' as _i811;
import 'package:mestio/core/feedback/feedback_data_source.dart' as _i135;
import 'package:mestio/core/reliability/connectivity_service.dart' as _i467;
import 'package:mestio/core/reliability/report_outbox.dart' as _i637;
import 'package:mestio/features/announcements/data/datasources/announcements_data_source.dart'
    as _i771;
import 'package:mestio/features/announcements/data/repositories/announcements_repository.dart'
    as _i796;
import 'package:mestio/features/announcements/presentation/cubit/announcements_cubit.dart'
    as _i546;
import 'package:mestio/features/auth/data/datasources/auth_data_source.dart'
    as _i350;
import 'package:mestio/features/auth/data/repositories/account_bootstrap_repository.dart'
    as _i696;
import 'package:mestio/features/auth/data/repositories/auth_repository.dart'
    as _i931;
import 'package:mestio/features/auth/presentation/cubit/forgot_password_cubit.dart'
    as _i711;
import 'package:mestio/features/auth/presentation/cubit/login_cubit.dart'
    as _i438;
import 'package:mestio/features/auth/presentation/cubit/register_cubit.dart'
    as _i916;
import 'package:mestio/features/auth/presentation/cubit/reset_password_cubit.dart'
    as _i597;
import 'package:mestio/features/auth/presentation/cubit/welcome_cubit.dart'
    as _i776;
import 'package:mestio/features/connectivity/data/datasources/connectivity_data_source.dart'
    as _i322;
import 'package:mestio/features/connectivity/data/repositories/connectivity_repository.dart'
    as _i113;
import 'package:mestio/features/connectivity/presentation/cubit/connectivity_cubit.dart'
    as _i120;
import 'package:mestio/features/contacts/data/datasources/contacts_data_source.dart'
    as _i359;
import 'package:mestio/features/contacts/data/repositories/contacts_repository.dart'
    as _i125;
import 'package:mestio/features/contacts/presentation/cubit/contacts_cubit.dart'
    as _i600;
import 'package:mestio/features/estate/data/datasources/estate_data_source.dart'
    as _i319;
import 'package:mestio/features/estate/data/datasources/estate_structure_data_source.dart'
    as _i321;
import 'package:mestio/features/estate/data/repositories/estate_repository.dart'
    as _i238;
import 'package:mestio/features/estate/data/repositories/estate_structure_repository.dart'
    as _i501;
import 'package:mestio/features/estate/presentation/cubit/estate_cubit.dart'
    as _i91;
import 'package:mestio/features/maintenance/data/datasources/maintenance_data_source.dart'
    as _i897;
import 'package:mestio/features/maintenance/data/repositories/maintenance_repository.dart'
    as _i21;
import 'package:mestio/features/maintenance/presentation/cubit/maintenance_cubit.dart'
    as _i115;
import 'package:mestio/features/moderation/data/datasources/content_moderation_data_source.dart'
    as _i1004;
import 'package:mestio/features/moderation/data/repositories/content_moderation_repository.dart'
    as _i1021;
import 'package:mestio/features/moderation/presentation/cubit/report_content_cubit.dart'
    as _i796;
import 'package:mestio/features/profiles/data/datasources/resident_spaces_data_source.dart'
    as _i736;
import 'package:mestio/features/profiles/data/datasources/shared_user_apps_data_source.dart'
    as _i873;
import 'package:mestio/features/profiles/data/datasources/shared_user_data_source.dart'
    as _i887;
import 'package:mestio/features/profiles/data/repositories/shared_user_apps_repository.dart'
    as _i132;
import 'package:mestio/features/profiles/data/repositories/shared_user_repository.dart'
    as _i719;
import 'package:mestio/features/profiles/presentation/cubit/profile_cubit.dart'
    as _i539;
import 'package:mestio/features/profiles/presentation/cubit/resident_spaces_cubit.dart'
    as _i554;
import 'package:mestio/features/report_comments/data/datasources/report_comments_data_source.dart'
    as _i576;
import 'package:mestio/features/report_comments/data/repositories/report_comments_repository.dart'
    as _i758;
import 'package:mestio/features/report_comments/presentation/cubit/report_comments_cubit.dart'
    as _i373;
import 'package:mestio/features/reports/data/datasources/reports_local_data_source.dart'
    as _i2;
import 'package:mestio/features/reports/data/datasources/reports_remote_data_source.dart'
    as _i1015;
import 'package:mestio/features/reports/data/repositories/reports_repository.dart'
    as _i426;
import 'package:mestio/features/reports/presentation/cubit/estate_cubit.dart'
    as _i941;
import 'package:mestio/features/reports/presentation/cubit/reports_cubit.dart'
    as _i518;
import 'package:mestio/features/reports/services/fcm_service.dart' as _i948;
import 'package:mestio/features/reports/services/location_service.dart'
    as _i530;
import 'package:mestio/features/residents/data/datasources/residents_data_source.dart'
    as _i460;
import 'package:mestio/features/residents/data/repositories/residents_repository.dart'
    as _i236;
import 'package:mestio/features/residents/presentation/cubit/residents_cubit.dart'
    as _i1035;
import 'package:mestio/features/resolutions/data/datasources/resolutions_data_source.dart'
    as _i245;
import 'package:mestio/features/resolutions/data/repositories/resolutions_repository.dart'
    as _i804;
import 'package:mestio/features/resolutions/presentation/cubit/resolutions_cubit.dart'
    as _i343;
import 'package:mestio/features/subscription/data/datasources/subscription_data_source.dart'
    as _i115;
import 'package:mestio/features/subscription/data/repositories/subscription_repository.dart'
    as _i941;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => appModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i454.SupabaseClient>(() => appModule.supabaseClient);
    gh.lazySingleton<_i161.InternetConnection>(
      () => appModule.internetConnection,
    );
    gh.lazySingleton<_i115.SubscriptionDataSource>(
      () => appModule.subscriptionDataSource,
    );
    gh.lazySingleton<_i467.ConnectivityService>(
      () => _i467.ConnectivityService(),
    );
    gh.lazySingleton<_i948.FcmService>(() => _i948.FcmService());
    gh.lazySingleton<_i530.LocationService>(() => _i530.LocationService());
    gh.lazySingleton<_i1051.PaywallPresenter>(
      () => _i1051.AppPaywallPresenter(),
    );
    gh.lazySingleton<_i1004.ContentModerationDataSource>(
      () => _i1004.ContentModerationDataSourceImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i350.AuthDataSource>(
      () => _i350.SupabaseAuthDataSource(
        gh<_i454.SupabaseClient>(),
        gh<_i948.FcmService>(),
      ),
    );
    gh.lazySingleton<_i2.ReportsLocalDataSource>(
      () => _i2.ReportsLocalDataSourceImpl(),
    );
    gh.lazySingleton<_i135.FeedbackDataSource>(
      () => _i135.FeedbackDataSourceImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i873.SharedUserAppsDataSource>(
      () => _i873.SupabaseSharedUserAppsDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i319.EstateDataSource>(
      () => _i319.EstateDataSourceImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i321.EstateStructureDataSource>(
      () => _i321.EstateStructureDataSourceImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i132.SharedUserAppsRepository>(
      () => _i132.SharedUserAppsRepositoryImpl(
        gh<_i873.SharedUserAppsDataSource>(),
      ),
    );
    gh.lazySingleton<_i245.ResolutionsDataSource>(
      () => _i245.ResolutionsDataSourceImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i1021.ContentModerationRepository>(
      () => _i1021.ContentModerationRepositoryImpl(
        gh<_i1004.ContentModerationDataSource>(),
      ),
    );
    gh.lazySingleton<_i359.ContactsDataSource>(
      () => _i359.ContactsDataSourceImpl(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i796.ReportContentCubit>(
      () => _i796.ReportContentCubit(gh<_i1021.ContentModerationRepository>()),
    );
    gh.lazySingleton<_i460.ResidentsDataSource>(
      () => _i460.ResidentsDataSourceImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i897.MaintenanceDataSource>(
      () => _i897.MaintenanceDataSourceImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i1053.AppLocaleDataSource>(
      () => _i1053.SharedPreferencesAppLocaleDataSource(
        gh<_i460.SharedPreferences>(),
      ),
    );
    gh.lazySingleton<_i576.ReportCommentsDataSource>(
      () => _i576.ReportCommentsDataSourceImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i1015.ReportsRemoteDataSource>(
      () => _i1015.ReportsRemoteDataSourceImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i771.AnnouncementsDataSource>(
      () => _i771.AnnouncementsDataSourceImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i426.ReportsRepository>(
      () => _i426.ReportsRepositoryImpl(
        gh<_i2.ReportsLocalDataSource>(),
        gh<_i1015.ReportsRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i1044.AppLocaleRepository>(
      () => _i1044.AppLocaleRepositoryImpl(gh<_i1053.AppLocaleDataSource>()),
    );
    gh.lazySingleton<_i501.EstateStructureRepository>(
      () => _i501.EstateStructureRepositoryImpl(
        gh<_i321.EstateStructureDataSource>(),
      ),
    );
    gh.lazySingleton<_i887.SharedUserDataSource>(
      () => _i887.SupabaseSharedUserDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i719.SharedUserRepository>(
      () => _i719.SharedUserRepositoryImpl(gh<_i887.SharedUserDataSource>()),
    );
    gh.lazySingleton<_i941.SubscriptionRepository>(
      () =>
          _i941.SubscriptionRepositoryImpl(gh<_i115.SubscriptionDataSource>()),
    );
    gh.lazySingleton<_i322.ConnectivityDataSource>(
      () => _i322.InternetConnectionDataSource(gh<_i161.InternetConnection>()),
    );
    gh.lazySingleton<_i520.ReviewPresenter>(
      () => _i520.AppReviewPresenter(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i238.EstateRepository>(
      () => _i238.EstateRepositoryImpl(gh<_i319.EstateDataSource>()),
    );
    gh.lazySingleton<_i736.ResidentSpacesDataSource>(
      () => _i736.ResidentSpacesDataSourceImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i125.ContactsRepository>(
      () => _i125.ContactsRepositoryImpl(gh<_i359.ContactsDataSource>()),
    );
    gh.factory<_i427.DataExportCubit>(
      () => _i427.DataExportCubit(
        gh<_i426.ReportsRepository>(),
        gh<_i719.SharedUserRepository>(),
        gh<_i238.EstateRepository>(),
      ),
    );
    gh.lazySingleton<_i236.ResidentsRepository>(
      () => _i236.ResidentsRepositoryImpl(gh<_i460.ResidentsDataSource>()),
    );
    gh.factory<_i973.DeleteAccountPreflightCubit>(
      () => _i973.DeleteAccountPreflightCubit(
        gh<_i132.SharedUserAppsRepository>(),
      ),
    );
    gh.lazySingleton<_i731.AppLocaleCubit>(
      () => _i731.AppLocaleCubit(gh<_i1044.AppLocaleRepository>()),
    );
    gh.lazySingleton<_i113.ConnectivityRepository>(
      () =>
          _i113.ConnectivityRepositoryImpl(gh<_i322.ConnectivityDataSource>()),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i804.ResolutionsRepository>(
      () => _i804.ResolutionsRepositoryImpl(gh<_i245.ResolutionsDataSource>()),
    );
    gh.factory<_i1035.ResidentsCubit>(
      () => _i1035.ResidentsCubit(
        gh<_i236.ResidentsRepository>(),
        gh<_i238.EstateRepository>(),
      ),
    );
    gh.lazySingleton<_i120.ConnectivityCubit>(
      () => _i120.ConnectivityCubit(gh<_i113.ConnectivityRepository>()),
    );
    gh.factory<_i941.EstateCubit>(
      () => _i941.EstateCubit(gh<_i501.EstateStructureRepository>()),
    );
    gh.lazySingleton<_i21.MaintenanceRepository>(
      () => _i21.MaintenanceRepositoryImpl(gh<_i897.MaintenanceDataSource>()),
    );
    gh.lazySingleton<_i696.AccountBootstrapRepository>(
      () => _i696.AccountBootstrapRepositoryImpl(
        gh<_i719.SharedUserRepository>(),
        gh<_i873.SharedUserAppsDataSource>(),
      ),
    );
    gh.factory<_i91.EstateMembershipCubit>(
      () => _i91.EstateMembershipCubit(gh<_i238.EstateRepository>()),
    );
    gh.factory<_i554.ResidentSpacesCubit>(
      () => _i554.ResidentSpacesCubit(gh<_i736.ResidentSpacesDataSource>()),
    );
    gh.lazySingleton<_i758.ReportCommentsRepository>(
      () => _i758.ReportCommentsRepositoryImpl(
        gh<_i576.ReportCommentsDataSource>(),
      ),
    );
    gh.lazySingleton<_i796.AnnouncementsRepository>(
      () => _i796.AnnouncementsRepositoryImpl(
        gh<_i771.AnnouncementsDataSource>(),
      ),
    );
    gh.factory<_i600.ContactsCubit>(
      () => _i600.ContactsCubit(
        gh<_i125.ContactsRepository>(),
        gh<_i238.EstateRepository>(),
      ),
    );
    gh.lazySingleton<_i637.ReportOutbox>(
      () => _i637.ReportOutbox(
        gh<_i2.ReportsLocalDataSource>(),
        gh<_i1015.ReportsRemoteDataSource>(),
        gh<_i467.ConnectivityService>(),
      ),
    );
    gh.factory<_i115.MaintenanceCubit>(
      () => _i115.MaintenanceCubit(gh<_i21.MaintenanceRepository>()),
    );
    gh.factory<_i539.ProfileCubit>(
      () => _i539.ProfileCubit(gh<_i719.SharedUserRepository>()),
    );
    gh.factory<_i343.ResolutionsCubit>(
      () => _i343.ResolutionsCubit(
        gh<_i804.ResolutionsRepository>(),
        gh<_i238.EstateRepository>(),
      ),
    );
    gh.factory<_i373.ReportCommentsCubit>(
      () => _i373.ReportCommentsCubit(gh<_i758.ReportCommentsRepository>()),
    );
    gh.factory<_i546.AnnouncementsCubit>(
      () => _i546.AnnouncementsCubit(
        gh<_i796.AnnouncementsRepository>(),
        gh<_i238.EstateRepository>(),
      ),
    );
    gh.lazySingleton<_i931.AuthRepository>(
      () => _i931.AuthRepositoryImpl(
        gh<_i350.AuthDataSource>(),
        gh<_i696.AccountBootstrapRepository>(),
      ),
    );
    gh.factory<_i407.AccountActionsCubit>(
      () => _i407.AccountActionsCubit(
        gh<_i931.AuthRepository>(),
        gh<_i941.SubscriptionRepository>(),
      ),
    );
    gh.factory<_i711.ForgotPasswordCubit>(
      () => _i711.ForgotPasswordCubit(gh<_i931.AuthRepository>()),
    );
    gh.factory<_i438.LoginCubit>(
      () => _i438.LoginCubit(gh<_i931.AuthRepository>()),
    );
    gh.factory<_i916.RegisterCubit>(
      () => _i916.RegisterCubit(gh<_i931.AuthRepository>()),
    );
    gh.factory<_i597.ResetPasswordCubit>(
      () => _i597.ResetPasswordCubit(gh<_i931.AuthRepository>()),
    );
    gh.factory<_i776.WelcomeCubit>(
      () => _i776.WelcomeCubit(gh<_i931.AuthRepository>()),
    );
    gh.lazySingleton<_i345.SessionRepository>(
      () => _i345.SessionRepositoryImpl(
        gh<_i931.AuthRepository>(),
        gh<_i719.SharedUserRepository>(),
        gh<_i941.SubscriptionRepository>(),
      ),
    );
    gh.factory<_i518.ReportsCubit>(
      () => _i518.ReportsCubit(
        gh<_i426.ReportsRepository>(),
        gh<_i345.SessionRepository>(),
        gh<_i238.EstateRepository>(),
        gh<_i948.FcmService>(),
        gh<_i637.ReportOutbox>(),
        gh<_i236.ResidentsRepository>(),
      ),
    );
    gh.lazySingleton<_i850.SessionCubit>(
      () => _i850.SessionCubit(gh<_i345.SessionRepository>()),
    );
    return this;
  }
}

class _$AppModule extends _i811.AppModule {}
