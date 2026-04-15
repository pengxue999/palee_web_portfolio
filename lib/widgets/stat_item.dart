import 'package:flutter/material.dart';
import 'package:palee_web_portfolio/utils/responsive_helper.dart';

/// Reusable statistics item widget
class StatItem extends StatelessWidget {
  final String number;
  final String label;
  final Color? textColor;

  const StatItem({
    super.key,
    required this.number,
    required this.label,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColor = textColor ?? Colors.white;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Text(
              number,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 20,
                  tablet: 30,
                  desktop: 40,
                ),
                fontWeight: FontWeight.bold,
                color: defaultColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 14,
                  tablet: 15,
                  desktop: 16,
                ),
                color: defaultColor.withOpacity(0.9),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
