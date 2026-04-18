import 'package:flutter/material.dart';
import 'package:palee_web_portfolio/utils/responsive_helper.dart';

/// Modern contact card widget with gradient icon and info display
class ModernContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String info;
  final Color color;
  final Color accentColor;
  final String actionLabel;
  final VoidCallback? onTap;

  const ModernContactCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.info,
    required this.color,
    required this.accentColor,
    required this.actionLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveHelper.getResponsiveSpacing(
      context,
      mobile: 22,
      tablet: 24,
      desktop: 26,
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.all(spacing),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, accentColor.withValues(alpha: 0.08)],
              ),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.18),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.15),
                  blurRadius: 40,
                  offset: const Offset(0, 18),
                  spreadRadius: -10,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [color, accentColor],
                        ),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withValues(alpha: 0.28),
                            blurRadius: 28,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Icon(icon, size: 34, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              subtitle,
                              style: TextStyle(
                                fontSize:
                                    ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      mobile: 11,
                                      tablet: 11.5,
                                      desktop: 12,
                                    ),
                                color: const Color(0xFF334155),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                mobile: 21,
                                tablet: 22,
                                desktop: 24,
                              ),
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0f172a),
                              letterSpacing: -0.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                SelectableText(
                  info,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      mobile: 15,
                      tablet: 15.5,
                      desktop: 16,
                    ),
                    color: const Color(0xFF1e293b),
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          actionLabel,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              mobile: 13,
                              tablet: 13.5,
                              desktop: 14,
                            ),
                            color: const Color(0xFF0f172a),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: accentColor,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
