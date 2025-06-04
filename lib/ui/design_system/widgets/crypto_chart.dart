import 'package:flutter/material.dart';
import '../app_theme.dart';

class CryptoChart extends StatelessWidget {
  final List<double> data;
  final bool isPositive;

  const CryptoChart({
    super.key,
    required this.data,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: CustomPaint(
        painter: ChartPainter(
          data: data,
          color: isPositive ? AppTheme.profitColor : AppTheme.lossColor,
        ),
      ),
    );
  }
}

class ChartPainter extends CustomPainter {
  final List<double> data;
  final Color color;

  ChartPainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final double stepX = size.width / (data.length - 1);
    final double maxY = data.reduce((a, b) => a > b ? a : b);
    final double minY = data.reduce((a, b) => a < b ? a : b);
    final double range = maxY - minY;

    for (int i = 0; i < data.length; i++) {
      final double x = i * stepX;
      final double y = range == 0 
          ? size.height / 2 
          : size.height - ((data[i] - minY) / range) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Desenhar área sob a curva
    final areaPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final areaPath = Path.from(path);
    areaPath.lineTo(size.width, size.height);
    areaPath.lineTo(0, size.height);
    areaPath.close();

    canvas.drawPath(areaPath, areaPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
} 