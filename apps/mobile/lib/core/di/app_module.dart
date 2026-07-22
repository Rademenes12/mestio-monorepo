import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/subscription/data/datasources/revenuecat_subscription_data_source.dart';
import '../../features/subscription/data/datasources/subscription_data_source.dart';
import '../config/revenuecat_config.dart';

@module
abstract class AppModule {
  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  @lazySingleton
  SupabaseClient get supabaseClient => Supabase.instance.client;

  @lazySingleton
  InternetConnection get internetConnection => InternetConnection();

  /// Uses real RevenueCat when API keys are configured, otherwise falls back
  /// to [FakeSubscriptionDataSource] for development.
  @lazySingleton
  SubscriptionDataSource get subscriptionDataSource =>
      RevenueCatConfig.isEnabled
          ? RevenueCatSubscriptionDataSource()
          : FakeSubscriptionDataSource();
}
