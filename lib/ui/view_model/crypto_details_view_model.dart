import 'package:flutter/material.dart';

import '../../domain/repositories/crypto_repository.dart';
import '../../domain/models/coin_data/coin_data_model.dart';
import '../../core/utils/delayed_result.dart';
import '../../core/utils/app_formatters.dart';

class CryptoDetailsViewModel extends ChangeNotifier {
  final CryptoRepository cryptoRepository;
  final String coinId;

  CryptoDetailsViewModel({
    required this.cryptoRepository,
    required this.coinId,
  }) {
    loadCoinDetails();
  }

  // Estado dos detalhes da moeda
  DelayedResult<CoinDataModel> _coinDetailsResult = const DelayedResult.idle();

  // Getters
  DelayedResult<CoinDataModel> get coinDetailsResult => _coinDetailsResult;
  CoinDataModel? get coinData => _coinDetailsResult.value;
  bool get isLoading => _coinDetailsResult.isInProgress;
  bool get hasError => _coinDetailsResult.isError;
  bool get hasData => _coinDetailsResult.isSuccessful;
  String? get errorMessage => _coinDetailsResult.error?.toString();

  // Load coin details
  Future<void> loadCoinDetails() async {
    _coinDetailsResult = const DelayedResult.inProgress();
    notifyListeners();

    final result = await cryptoRepository.coinDataById(coinId);
    
    result.fold(
      (failure) {
        _coinDetailsResult = DelayedResult.fromError(Exception(failure.message));
        debugPrint('Error loading coin details: ${failure.message}');
      },
      (coinData) {
        _coinDetailsResult = DelayedResult.fromValue(coinData);
        debugPrint('Coin details loaded: ${coinData.name}');
      },
    );
    
    notifyListeners();
  }

  // Reload details
  Future<void> refreshCoinDetails() async {
    await loadCoinDetails();
  }

  // Get formatted USD price
  String get currentPriceUSD {
    final price = coinData?.marketData.currentPrice['usd'];
    return AppFormatters.formatPrice(price as num?);
  }

  // Get formatted 24h price change
  String get priceChange24h {
    final change = coinData?.marketData.priceChange24h;
    return AppFormatters.formatPercentageChange(change);
  }

  // Check if price went up or down
  bool get isPriceUp {
    final change = coinData?.marketData.priceChange24h;
    return change != null && change >= 0;
  }

  // Get formatted market cap
  String get marketCapUSD {
    final marketCap = coinData?.marketData.marketCap['usd'];
    return AppFormatters.formatMarketValue(marketCap);
  }

  // Get formatted volume
  String get volumeUSD {
    final volume = coinData?.marketData.totalVolume['usd'];
    return AppFormatters.formatMarketValue(volume);
  }

  // Get English description
  String get description {
    final desc = coinData?.description['en'];
    return AppFormatters.cleanAndLimitText(desc);
  }

  // Get chart data (7-day sparkline)
  List<double> get chartData {
    return coinData?.marketData.sparkline7d.price ?? [];
  }
}