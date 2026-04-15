import 'package:flutter/material.dart';
import 'package:palee_web_portfolio/utils/responsive_helper.dart';
import 'package:palee_web_portfolio/widgets/animated_section.dart';

/// Reusable section header widget with title and decorative line
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Color? lineColor;
  final double? lineWidth;
  final TextAlign textAlign;
  final Duration animationDelay;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.lineColor,
    this.lineWidth,
    this.textAlign = TextAlign.center,
    this.animationDelay = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSection(
      delay: animationDelay,
      child: Column(
        children: [
          Text(
            title,
            textAlign: textAlign,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 26,
                tablet: 30,
                desktop: 40,
              ),
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade900,
              height: 1.2,
              letterSpacing: -0.5,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 16),
            Text(
              subtitle!,
              textAlign: textAlign,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 16,
                  tablet: 18,
                  desktop: 20,
                ),
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade600,
                height: 1.6,
              ),
            ),
          ],
          const SizedBox(height: 16),
          AnimatedSection(
            delay: Duration(milliseconds: animationDelay.inMilliseconds + 200),
            child: Container(
              width:
                  lineWidth ??
                  ResponsiveHelper.getResponsiveSpacing(
                    context,
                    mobile: 60,
                    tablet: 80,
                    desktop: 100,
                  ),
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: lineColor != null
                      ? [lineColor!, lineColor!.withOpacity(0.7)]
                      : [Colors.blue.shade700, Colors.blue.shade500],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
