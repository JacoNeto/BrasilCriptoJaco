import 'package:brasil_cripto/app.dart';
import 'package:brasil_cripto/data/services/api_service.dart';
import 'package:brasil_cripto/domain/repositories/crypto_repository.dart';
import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';

import 'data/repositories/local_favorites_repository.dart';
import 'data/repositories/remote_crypto_repository.dart';
import 'data/services/hive_service.dart';
import 'domain/repositories/favorites_repository.dart';

Future<void> _setupDependencies() async {
  final getIt = GetIt.instance;
  getIt.registerSingleton<CryptoRepository>(
    RemoteCryptoRepository(apiService: ApiService()),
  );
  getIt.registerSingletonAsync<FavoritesRepository>(
    () async {
      final hiveService = HiveService();
      await hiveService.initializeHive();
      return LocalFavoritesRepository(hiveService: hiveService);
    },
  );
  await getIt.allReady();
}

void main() async {
  await _setupDependencies();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BrasilCriptoApp()); 
}

