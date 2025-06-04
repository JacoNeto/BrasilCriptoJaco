import 'package:flutter/material.dart';

class CryptoDetailsLoadingView extends StatelessWidget {
  const CryptoDetailsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carregando...'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
} 