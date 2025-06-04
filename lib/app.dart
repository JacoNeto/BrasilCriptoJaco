import 'package:brasil_cripto/domain/repositories/favorites_repository.dart';
import 'package:brasil_cripto/ui/design_system/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'domain/repositories/crypto_repository.dart';
import 'ui/view/home/home_view.dart';
import 'ui/view_model/favorites_view_model.dart';
import 'ui/view_model/home_view_model.dart';

class BrasilCriptoApp extends StatelessWidget {
  const BrasilCriptoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HomeViewModel(
            cryptoRepository: GetIt.instance<CryptoRepository>(), 
            favoritesRepository: GetIt.instance<FavoritesRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => FavoritesViewModel(
            favoritesRepository: GetIt.instance<FavoritesRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'BrasilCripto',
        theme: AppTheme.theme,
        home: const HomeView(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
