import 'package:flutter/material.dart';

import '../../domain/repositories/crypto_repository.dart';
import '../../domain/models/coin_data/coin_data_model.dart';
import '../../core/utils/delayed_result.dart';

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

  // Carregar detalhes da moeda
  Future<void> loadCoinDetails() async {
    _coinDetailsResult = const DelayedResult.inProgress();
    notifyListeners();

    final result = await cryptoRepository.coinDataById(coinId);
    
    result.fold(
      (failure) {
        _coinDetailsResult = DelayedResult.fromError(Exception(failure.message));
        debugPrint('Erro ao carregar detalhes da moeda: ${failure.message}');
      },
      (coinData) {
        _coinDetailsResult = DelayedResult.fromValue(coinData);
        debugPrint('Detalhes da moeda carregados: ${coinData.name}');
      },
    );
    
    notifyListeners();
  }

  // Recarregar detalhes
  Future<void> refreshCoinDetails() async {
    await loadCoinDetails();
  }

  // Obter preço em USD formatado
  String get currentPriceUSD {
    final price = coinData?.marketData.currentPrice['usd'];
    if (price == null) return 'N/A';
    return '\$${price.toStringAsFixed(2)}';
  }

  // Obter mudança de preço em 24h formatada
  String get priceChange24h {
    final change = coinData?.marketData.priceChange24h;
    if (change == null) return 'N/A';
    final sign = change >= 0 ? '+' : '';
    return '$sign${change.toStringAsFixed(2)}%';
  }

  // Verificar se o preço subiu ou desceu
  bool get isPriceUp {
    final change = coinData?.marketData.priceChange24h;
    return change != null && change >= 0;
  }

  // Obter market cap formatado
  String get marketCapUSD {
    final marketCap = coinData?.marketData.marketCap['usd'];
    if (marketCap == null) return 'N/A';
    
    if (marketCap >= 1e12) {
      return '\$${(marketCap / 1e12).toStringAsFixed(2)}T';
    } else if (marketCap >= 1e9) {
      return '\$${(marketCap / 1e9).toStringAsFixed(2)}B';
    } else if (marketCap >= 1e6) {
      return '\$${(marketCap / 1e6).toStringAsFixed(2)}M';
    } else {
      return '\$${marketCap.toStringAsFixed(0)}';
    }
  }

  // Obter volume formatado
  String get volumeUSD {
    final volume = coinData?.marketData.totalVolume['usd'];
    if (volume == null) return 'N/A';
    
    if (volume >= 1e12) {
      return '\$${(volume / 1e12).toStringAsFixed(2)}T';
    } else if (volume >= 1e9) {
      return '\$${(volume / 1e9).toStringAsFixed(2)}B';
    } else if (volume >= 1e6) {
      return '\$${(volume / 1e6).toStringAsFixed(2)}M';
    } else {
      return '\$${volume.toStringAsFixed(0)}';
    }
  }

  // Obter descrição em inglês
  String get description {
    final desc = coinData?.description['en'];
    if (desc == null || desc.isEmpty) return 'Descrição não disponível';
    
    // Remover tags HTML básicas e quebras de linha
    String cleanDesc = desc.toString()
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(r'\r\n', '\n')
        .replaceAll(r'\n\n', '\n');
    
    // Limitar a descrição a aproximadamente 500 caracteres
    if (cleanDesc.length > 500) {
      cleanDesc = '${cleanDesc.substring(0, 500)}...';
    }
    
    return cleanDesc;
  }

  // Obter dados do gráfico (sparkline 7 dias)
  List<double> get chartData {
    return coinData?.marketData.sparkline7d.price ?? [];
  }
}