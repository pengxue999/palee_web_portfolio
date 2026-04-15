import 'package:flutter/material.dart';
import 'package:palee_web_portfolio/utils/responsive_helper.dart';

/// Reusable info row widget for displaying icon and text
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? iconColor;
  final Color? textColor;
  final double? iconSize;
  final double? fontSize;

  const InfoRow({
    super.key,
    required this.icon,
    required this.text,
    this.iconColor,
    this.textColor,
    this.iconSize,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final defaultIconColor = iconColor ?? Colors.white;
    final defaultTextColor = textColor ?? Colors.white;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: defaultIconColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: defaultIconColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Icon(icon, size: iconSize ?? 16, color: defaultIconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize ?? 14,
              color: defaultTextColor,
              fontWeight: FontWeight.w500,
              shadows: defaultTextColor == Colors.white
                  ? [
                      const Shadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
