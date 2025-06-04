class AppFormatters {
  // Brazilian Portuguese month abbreviations
  static const List<String> _monthsShort = [
    'jan', 'fev', 'mar', 'abr', 'mai', 'jun',
    'jul', 'ago', 'set', 'out', 'nov', 'dez'
  ];

  static String getFormattedDateTime(int dataPointIndex, int totalDataPoints) {
    // Calculate how many hours ago this data point represents
    final hoursTotal = 7 * 24; // 168 hours in 7 days
    final hoursFromEnd = ((totalDataPoints - 1 - dataPointIndex) / (totalDataPoints - 1)) * hoursTotal;
    
    // Calculate the actual date/time
    final now = DateTime.now();
    final dataTime = now.subtract(Duration(hours: hoursFromEnd.round()));
    
    // Format date components
    final day = dataTime.day.toString().padLeft(2, '0');
    final month = _monthsShort[dataTime.month - 1];
    final year = dataTime.year.toString().substring(2); // Last 2 digits
    final time = '${dataTime.hour.toString().padLeft(2, '0')}:${dataTime.minute.toString().padLeft(2, '0')}';
    
    // Return formatted date and time
    return '$day $month $year, $time';
  }

  /// Format price with Brazilian number formatting (periods for thousands, comma for decimal)
  /// Example: 105603.00 becomes $105.603,00
  static String formatPrice(num? price) {
    if (price == null) return 'N/A';
    
    // Format price with Brazilian/European style (periods for thousands, comma for decimal)
    if (price >= 1000) {
      // For prices >= 1000, use periods for thousands and comma for decimal
      final formattedPrice = price.toStringAsFixed(2);
      final parts = formattedPrice.split('.');
      final integerPart = parts[0];
      final decimalPart = parts.length > 1 ? parts[1] : '00';
      
      // Add periods to integer part for thousands separator
      final withPeriods = integerPart.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      );
      
      return '\$$withPeriods,$decimalPart';
    } else if (price >= 1) {
      // For prices between 1-999, replace dot with comma
      return '\$${price.toStringAsFixed(2)}'.replaceAll('.', ',');
    } else if (price >= 0.01) {
      // For prices between 0.01-0.99, show 4 decimal places with comma
      return '\$${price.toStringAsFixed(4)}'.replaceAll('.', ',');
    } else {
      // For very small prices, show 8 decimal places with comma
      return '\$${price.toStringAsFixed(8)}'.replaceAll('.', ',');
    }
  }
}