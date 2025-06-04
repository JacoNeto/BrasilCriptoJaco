import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/crypto_details_view_model.dart';
import 'components/loading_view.dart';
import 'components/error_view.dart';
import 'components/coin_details_content.dart';

class CryptoDetailsView extends StatelessWidget {
  const CryptoDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CryptoDetailsViewModel>(
        builder: (context, viewModel, _) {
          // Loading state
          if (viewModel.isLoading) {
            return const CryptoDetailsLoadingView();
          }

          // Error state
          if (viewModel.hasError) {
            return CryptoDetailsErrorView(
              errorMessage: viewModel.errorMessage ?? 'Erro desconhecido',
              onRetry: viewModel.refreshCoinDetails,
            );
          }

          // Success state
          if (viewModel.hasData && viewModel.coinData != null) {
            return CoinDetailsContent(viewModel: viewModel);
          }

          // Fallback
          return const CryptoDetailsLoadingView();
        },
      ),
    );
  }
}