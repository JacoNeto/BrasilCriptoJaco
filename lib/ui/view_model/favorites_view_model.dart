import 'package:flutter/material.dart';

import '../../domain/repositories/favorites_repository.dart';

class FavoritesViewModel extends ChangeNotifier {
  final FavoritesRepository favoritesRepository;

  FavoritesViewModel({required this.favoritesRepository});
}