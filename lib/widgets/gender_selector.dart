import 'package:flutter/material.dart';

class GenderSelector extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onChanged;
  final Color surfaceColor;
  final Color borderColor;
  final Color textColor;

  const GenderSelector({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.surfaceColor,
    required this.borderColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _tile('ຊາຍ', Icons.male_rounded, const Color(0xFF3B82F6)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _tile('ຍິງ', Icons.female_rounded, const Color(0xFFEC4899)),
        ),
      ],
    );
  }

  Widget _tile(String value, IconData icon, Color color) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 56,
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.08) : surfaceColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : borderColor,
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? color : textColor, size: 22),
            const SizedBox(width: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected ? color : textColor,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: const Icon(
                  Icons.check_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
