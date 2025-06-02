import 'package:flutter/material.dart';

import '../../domain/repositories/crypto_repository.dart';

class CryptoDetailsViewModel extends ChangeNotifier {
  final CryptoRepository cryptoRepository;

  CryptoDetailsViewModel({required this.cryptoRepository});
}