import 'package:flutter/material.dart';

class CryptoSearchField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String searchQuery;

  const CryptoSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Pesquisar criptomoedas...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
              )
            : null,
      ),
    );
  }
} 