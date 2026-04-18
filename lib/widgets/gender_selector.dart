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
        Expanded(child: _tile('ຊາຍ', Colors.blue)),
        const SizedBox(width: 10),
        Expanded(child: _tile('ຍິງ', Colors.pink)),
      ],
    );
  }

  Widget _tile(String value, Color color) {
    final isSelected = selected == value;
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: isSelected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => onChanged(value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: isSelected ? color.withValues(alpha: 0.08) : surfaceColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? color : borderColor,
                width: isSelected ? 2 : 1.5,
              ),
            ),
            child: Row(
              children: [
                Radio<String>(
                  value: value,
                  groupValue: selected,
                  onChanged: onChanged,
                  activeColor: color,
                  visualDensity: VisualDensity.compact,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w400,
                      color: isSelected ? color : textColor,
                    ),
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
