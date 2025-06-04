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

    // Calculate min and max values for better scaling
    final minY = chartData.reduce((a, b) => a < b ? a : b);
    final maxY = chartData.reduce((a, b) => a > b ? a : b);
    final padding = (maxY - minY) * 0.1; // 10% padding

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20.0, 20.0, 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Gráfico 7 Dias',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (viewModel.isPriceUp ? AppTheme.profitColor : AppTheme.lossColor).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        viewModel.isPriceUp ? Icons.trending_up : Icons.trending_down,
                        size: 16,
                        color: viewModel.isPriceUp ? AppTheme.profitColor : AppTheme.lossColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '7D',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: viewModel.isPriceUp ? AppTheme.profitColor : AppTheme.lossColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  minY: minY - padding,
                  maxY: maxY + padding,
                  // Beautiful grid
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    drawHorizontalLine: true,
                    horizontalInterval: (maxY - minY) / 4,
                    verticalInterval: chartData.length / 6,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: AppTheme.textTertiary.withOpacity(0.1),
                        strokeWidth: 1,
                        dashArray: [5, 5],
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: AppTheme.textTertiary.withOpacity(0.1),
                        strokeWidth: 1,
                        dashArray: [5, 5],
                      );
                    },
                  ),
                  // Axis labels
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 65,
                        interval: (maxY - minY) / 4,
                        getTitlesWidget: (value, meta) {
                          final isEdgeValue = value <= minY + (maxY - minY) * 0.05 || 
                                            value >= maxY - (maxY - minY) * 0.05;
                          
                          if (isEdgeValue) {
                            return const SizedBox.shrink();
                          }
                          
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              AppFormatters.formatPriceCompact(value),
                              style: TextStyle(
                                color: AppTheme.textTertiary,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        interval: chartData.length / 6,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= chartData.length) return const SizedBox.shrink();
                          
                          String label;
                          if (index == 0) {
                            label = '7d atrás';
                          } else if (index >= chartData.length - 1) {
                            label = 'Hoje';
                          } else {
                            final daysAgo = (7 * (chartData.length - 1 - index) / (chartData.length - 1)).round();
                            label = '${daysAgo}d';
                          }
                          
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              label,
                              style: TextStyle(
                                color: AppTheme.textTertiary,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Subtle border
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: AppTheme.textTertiary.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  // Enhanced touch interaction
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) => AppTheme.cardColor.withOpacity(0.95),
                      tooltipRoundedRadius: 8,
                      tooltipPadding: const EdgeInsets.all(12),
                      tooltipMargin: 8,
                      tooltipBorder: BorderSide(
                        color: (viewModel.isPriceUp ? AppTheme.profitColor : AppTheme.lossColor).withOpacity(0.3),
                        width: 1,
                      ),
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
                      // Optional: Add haptic feedback
                    },
                    handleBuiltInTouches: true,
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: chartData.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value);
                      }).toList(),
                      isCurved: true,
                      curveSmoothness: 0.35,
                      color: viewModel.isPriceUp ? AppTheme.profitColor : AppTheme.lossColor,
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 0,
                            color: Colors.transparent,
                            strokeWidth: 0,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            (viewModel.isPriceUp ? AppTheme.profitColor : AppTheme.lossColor).withOpacity(0.15),
                            (viewModel.isPriceUp ? AppTheme.profitColor : AppTheme.lossColor).withOpacity(0.05),
                            Colors.transparent,
                          ],
                        ),
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