import 'package:flutter/material.dart';

import '../../domain/repositories/crypto_repository.dart';

class FavoritesViewModel extends ChangeNotifier {
  final CryptoRepository cryptoRepository;

  FavoritesViewModel({required this.cryptoRepository});
}