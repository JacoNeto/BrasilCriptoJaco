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

  /// Format price in compact form for charts and small spaces
  /// Example: 45000 becomes $45K, 1200000 becomes $1.2M
  static String formatPriceCompact(num? price) {
    if (price == null) return 'N/A';
    
    if (price >= 1e12) {
      return '\$${(price / 1e12).toStringAsFixed(1).replaceAll('.', ',')}T';
    } else if (price >= 1e9) {
      return '\$${(price / 1e9).toStringAsFixed(1).replaceAll('.', ',')}B';
    } else if (price >= 1e6) {
      return '\$${(price / 1e6).toStringAsFixed(1).replaceAll('.', ',')}M';
    } else if (price >= 1e3) {
      return '\$${(price / 1e3).toStringAsFixed(1).replaceAll('.', ',')}K';
    } else if (price >= 1) {
      return '\$${price.toStringAsFixed(0)}';
    } else if (price >= 0.01) {
      return '\$${price.toStringAsFixed(2)}'.replaceAll('.', ',');
    } else {
      return '\$${price.toStringAsFixed(4)}'.replaceAll('.', ',');
    }
  }
}