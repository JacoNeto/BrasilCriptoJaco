import 'package:flutter/material.dart';

class CryptoDetailsView extends StatelessWidget {
  const CryptoDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Details'),
      ),
      body: const Center(
        child: Text('Crypto Details'),
      ),
    );
  }
}