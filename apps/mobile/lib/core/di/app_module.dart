import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/subscription/data/datasources/subscription_data_source.dart';

@module
abstract class AppModule {
  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  @lazySingleton
  SupabaseClient get supabaseClient => Supabase.instance.client;

  @lazySingleton
  InternetConnection get internetConnection => InternetConnection();

  @lazySingleton
  SubscriptionDataSource get subscriptionDataSource =>
      FakeSubscriptionDataSource();
}
