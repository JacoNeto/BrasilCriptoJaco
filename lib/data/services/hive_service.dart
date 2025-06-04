import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/models/coin/coin_model.dart';

class HiveService {
  static const String _coinsBoxName = 'coins';
  Box<CoinModel>? _coinBox;

  Future<void> initializeHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CoinModelAdapter());
    _coinBox = await Hive.openBox<CoinModel>(_coinsBoxName);
  }

  Box<CoinModel> get _box {
    if (_coinBox == null || !_coinBox!.isOpen) {
      throw StateError('Hive not initialized. Call initializeHive() first.');
    }
    return _coinBox!;
  }

  // Core CRUD operations with consistent error handling
  List<CoinModel> getAllCoins() {
    try {
      return _box.values.toList();
    } catch (e) {
      throw HiveServiceException('Failed to retrieve coins: $e');
    }
  }

  CoinModel? getCoinById(String? coinId) {
    if (coinId == null || coinId.isEmpty) return null;
    
    try {
      return _box.values.cast<CoinModel?>().firstWhere(
        (coin) => coin?.id == coinId,
        orElse: () => null,
      );
    } catch (e) {
      throw HiveServiceException('Failed to find coin with id $coinId: $e');
    }
  }

  bool coinExists(String? coinId) {
    if (coinId == null || coinId.isEmpty) return false;
    return getCoinById(coinId) != null;
  }

  Future<void> storeCoin(CoinModel coin) async {
    if (coin.id == null || coin.id!.isEmpty) {
      throw ArgumentError('Coin must have a valid ID to be stored');
  }

    try {
      await _box.put(coin.id!, coin);
    } catch (e) {
      throw HiveServiceException('Failed to store coin ${coin.id}: $e');
    }
  }

  Future<bool> deleteCoinById(String? coinId) async {
    if (coinId == null || coinId.isEmpty) return false;

    try {
      if (!coinExists(coinId)) return false;
      await _box.delete(coinId);
      return true;
    } catch (e) {
      throw HiveServiceException('Failed to delete coin $coinId: $e');
    }
  }

  Future<void> clearAllCoins() async {
    try {
      await _box.clear();
    } catch (e) {
      throw HiveServiceException('Failed to clear all coins: $e');
    }
  }

  // Service health check
  bool get isInitialized => _coinBox != null && _coinBox!.isOpen;
  
  int get coinCount => _box.length;

  Future<void> dispose() async {
    await _coinBox?.close();
    _coinBox = null;
  }
}

// Custom exception for better error handling
class HiveServiceException implements Exception {
  final String message;
  const HiveServiceException(this.message);
  
  @override
  String toString() => 'HiveServiceException: $message';
}

// Separate adapter for better organization
class CoinModelAdapter extends TypeAdapter<CoinModel> {
  @override
  final typeId = 0;

  @override
  CoinModel read(BinaryReader reader) {
    return CoinModel(
      id: reader.read(),
      name: reader.read(),
      symbol: reader.read(),
      apiSymbol: reader.read(),
      thumb: reader.read(),
      large: reader.read(),
      marketCapRank: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, CoinModel obj) {
    writer.write(obj.id);
    writer.write(obj.name);
    writer.write(obj.symbol);
    writer.write(obj.apiSymbol);
    writer.write(obj.thumb);
    writer.write(obj.large);
    writer.write(obj.marketCapRank);
  }
}
