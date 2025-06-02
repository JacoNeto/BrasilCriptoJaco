import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/models/coin/coin_model.dart';

class HiveService {
  Future<void> initializeHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CoinModelAdapter());
    await Hive.openBox<CoinModel>('coins');
  }

  Box<CoinModel> getCoinBox() {
    return Hive.box<CoinModel>('coins');
  }

  // Operações de alto nível para gerenciamento de moedas
  List<CoinModel> getAllCoins() {
    return getCoinBox().values.toList();
  }

  CoinModel? findCoinById(String? coinId) {
    if (coinId == null) return null;
    return getCoinBox().values.firstWhere(
      (coin) => coin.id == coinId,
      orElse: () => const CoinModel(),
    );
  }

  bool coinExists(String? coinId) {
    if (coinId == null) return false;
    final coin = findCoinById(coinId);
    return coin?.id != null;
  }

  String generateKeyForCoin(CoinModel coin) {
    return coin.id ?? '${coin.symbol}_${DateTime.now().millisecondsSinceEpoch}';
  }

  String? findKeyForCoin(CoinModel coin) {
    final coinBox = getCoinBox();
    for (final key in coinBox.keys) {
      final storedCoin = coinBox.get(key);
      if (storedCoin?.id == coin.id) {
        return key.toString();
      }
    }
    return null;
  }

  Future<void> storeCoin(CoinModel coin) async {
    final key = generateKeyForCoin(coin);
    await getCoinBox().put(key, coin);
  }

  Future<bool> deleteCoinById(String? coinId) async {
    if (coinId == null) return false;
    
    final coin = CoinModel(id: coinId);
    final key = findKeyForCoin(coin);
    
    if (key != null) {
      await getCoinBox().delete(key);
      return true;
    }
    return false;
  }

  Future<void> clearAllCoins() async {
    await getCoinBox().clear();
  }
}

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
