import 'package:brasil_cripto/app.dart';
import 'package:brasil_cripto/data/services/api_service.dart';
import 'package:brasil_cripto/domain/repositories/crypto_repository.dart';
import 'package:flutter/material.dart';

import 'data/repositories/remote_crypto_repository/remote_crypto_repository.dart';
import 'package:get_it/get_it.dart';

Future<void> _setupDependencies() async {
  final getIt = GetIt.instance;
  getIt.registerSingleton<CryptoRepository>(
    RemoteCryptoRepository(apiService: ApiService()),
  );
  await getIt.allReady();
}

void main() async {
  _setupDependencies();
  runApp(const BrasilCriptoApp()); 
}

