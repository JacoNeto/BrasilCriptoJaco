import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../view_model/crypto_details_view_model.dart';
import '../../../core/app_theme.dart';

class ChartSection extends StatelessWidget {
  final CryptoDetailsViewModel viewModel;

  const ChartSection({
    super.key,
    required this.viewModel,
  });

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
                          final dateTimeLabel = AppFormatters.getFormattedDateTime(dataPointIndex, chartData.length);
                          
                          return LineTooltipItem(
                            '${AppFormatters.formatPrice(price)}\n$dateTimeLabel',
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