import 'package:flutter/material.dart';
import 'package:palee_web_portfolio/utils/responsive_helper.dart';

/// Modern contact card widget with gradient icon and info display
class ModernContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String info;
  final Color color;
  final Color accentColor;
  final VoidCallback? onTap;

  const ModernContactCard({
    super.key,
    required this.icon,
    required this.title,
    required this.info,
    required this.color,
    required this.accentColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.all(
            ResponsiveHelper.getResponsiveSpacing(
              context,
              mobile: 28,
              tablet: 30,
              desktop: 32,
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black.withOpacity(0.06), width: 1),
            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(0.08),
                blurRadius: 60,
                offset: const Offset(0, 16),
                spreadRadius: 8,
              ),
            ],
          ),
          child: Column(
            children: [
              // Icon with modern glass effect
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withOpacity(0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Icon(icon, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    mobile: 22,
                    tablet: 23,
                    desktop: 24,
                  ),
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1a1a2e),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accentColor.withOpacity(0.05),
                      accentColor.withOpacity(0.02),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: accentColor.withOpacity(0.15),
                    width: 1.5,
                  ),
                ),
                child: SelectableText(
                  info,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      mobile: 14,
                      tablet: 14.5,
                      desktop: 15,
                    ),
                    color: const Color(0xFF1a1a2e),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
