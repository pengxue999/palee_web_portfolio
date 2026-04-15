import 'package:flutter/material.dart';
import 'package:palee_web_portfolio/utils/responsive_helper.dart';
import 'package:palee_web_portfolio/widgets/animated_card.dart';

/// Reusable course card widget
class CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  final double? width;

  const CourseCard({super.key, required this.course, this.width});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final cardWidth =
        width ??
        (isMobile
            ? double.infinity
            : ResponsiveHelper.isTablet(context)
            ? 300
            : 280);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedCard(
        backgroundColor: Colors.white,
        child: Container(
          width: cardWidth,
          padding: EdgeInsets.all(
            ResponsiveHelper.getResponsiveSpacing(
              context,
              mobile: 20,
              tablet: 22,
              desktop: 24,
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with gradient background
              Container(
                width: ResponsiveHelper.getResponsiveSpacing(
                  context,
                  mobile: 56,
                  tablet: 60,
                  desktop: 64,
                ),
                height: ResponsiveHelper.getResponsiveSpacing(
                  context,
                  mobile: 56,
                  tablet: 60,
                  desktop: 64,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: course['gradient'] as List<Color>,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: (course['gradient'] as List<Color>)[0].withOpacity(
                        0.3,
                      ),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  course['icon'] as IconData,
                  size: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    mobile: 28,
                    tablet: 30,
                    desktop: 32,
                  ),
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: ResponsiveHelper.getResponsiveSpacing(
                  context,
                  mobile: 16,
                  tablet: 18,
                  desktop: 20,
                ),
              ),
              // Title
              Text(
                course['title'] as String,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    mobile: 20,
                    tablet: 21,
                    desktop: 22,
                  ),
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade900,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              // Level badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  course['level'] as String,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      mobile: 11,
                      tablet: 11.5,
                      desktop: 12,
                    ),
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              SizedBox(
                height: ResponsiveHelper.getResponsiveSpacing(
                  context,
                  mobile: 12,
                  tablet: 14,
                  desktop: 16,
                ),
              ),
              // Description
              Text(
                course['description'] as String,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    mobile: 13,
                    tablet: 13.5,
                    desktop: 14,
                  ),
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
