import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../view_model/crypto_details_view_model.dart';
import '../../../core/app_theme.dart';

class ChartSection extends StatelessWidget {
  final CryptoDetailsViewModel viewModel;

  const ChartSection({
    super.key,
    required this.viewModel,
  });

  // Format price value for tooltip
  String _formatPrice(double price) {
    if (price >= 1000) {
      return '\$${price.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      )}';
    } else if (price >= 1) {
      return '\$${price.toStringAsFixed(2)}';
    } else {
      return '\$${price.toStringAsFixed(6)}';
    }
  }

  // Brazilian Portuguese month abbreviations
  List<String> get _monthsShort => [
    'jan', 'fev', 'mar', 'abr', 'mai', 'jun',
    'jul', 'ago', 'set', 'out', 'nov', 'dez'
  ];

  // Get formatted date and time
  String _getFormattedDateTime(int dataPointIndex, int totalDataPoints) {
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

  @override
  Widget build(BuildContext context) {
    final chartData = viewModel.chartData;
    
    if (chartData.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gráfico 7 Dias',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  // Enable touch with custom tooltip
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) => AppTheme.cardColor,
                      tooltipRoundedRadius: 8,
                      tooltipPadding: const EdgeInsets.all(8),
                      tooltipMargin: 8,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((touchedSpot) {
                          final price = touchedSpot.y;
                          final dataPointIndex = touchedSpot.x.toInt();
                          final dateTimeLabel = _getFormattedDateTime(dataPointIndex, chartData.length);
                          
                          return LineTooltipItem(
                            '${_formatPrice(price)}\n$dateTimeLabel',
                            TextStyle(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          );
                        }).toList();
                      },
                    ),
                    touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
                      // Optional: Add haptic feedback or other interactions
                    },
                    handleBuiltInTouches: true,
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: chartData.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value);
                      }).toList(),
                      isCurved: true,
                      color: viewModel.isPriceUp ? AppTheme.profitColor : AppTheme.lossColor,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: (viewModel.isPriceUp ? AppTheme.profitColor : AppTheme.lossColor)
                            .withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 