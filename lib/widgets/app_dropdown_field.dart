import 'package:flutter/material.dart';

class AppDropdownField<T> extends StatefulWidget {
  final String labelText;
  final String hintText;
  final IconData? prefixIcon;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;
  final bool isLoading;
  final bool enabled;
  final Color? iconColor;

  const AppDropdownField({
    super.key,
    required this.labelText,
    this.hintText = '',
    this.prefixIcon,
    this.value,
    required this.items,
    this.onChanged,
    this.validator,
    this.isLoading = false,
    this.enabled = true,
    this.iconColor,
  });

  @override
  State<AppDropdownField<T>> createState() => _AppDropdownFieldState<T>();
}

class _AppDropdownFieldState<T> extends State<AppDropdownField<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _iconScaleAnimation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _iconScaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleOpen() {
    setState(() => _isOpen = true);
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Colors
    final accentColor =
        widget.iconColor ??
        (isDark ? const Color(0xFF7C9EFF) : const Color(0xFF3D6AFF));
    final surfaceColor = isDark
        ? const Color(0xFF1E2030)
        : const Color(0xFFFAFAFF);
    final borderColor = isDark
        ? const Color(0xFF3A3D50)
        : const Color(0xFFE2E4F0);
    final iconBgColor = isDark
        ? const Color(0xFF2A2D40)
        : const Color(0xFFEEF1FF);
    final disabledSurface = isDark
        ? const Color(0xFF191B27)
        : const Color(0xFFF4F5FA);
    final disabledBorder = isDark
        ? const Color(0xFF2C2F42)
        : const Color(0xFFEAEBF3);
    final labelColor = isDark
        ? const Color(0xFF8890B0)
        : const Color(0xFF8891AA);
    final textColor = isDark
        ? const Color(0xFFE8EAFF)
        : const Color(0xFF1A1D2E);

    final isInteractive = widget.enabled && !widget.isLoading;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: _isOpen && isInteractive
            ? [
                BoxShadow(
                  color: accentColor.withOpacity(isDark ? 0.18 : 0.12),
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 1),
                ),
              ],
      ),
      child: DropdownButtonFormField<T>(
        value: widget.value,
        items: widget.items,
        onChanged: isInteractive ? widget.onChanged : null,
        onTap: isInteractive ? _handleOpen : null,
        validator: widget.validator,
        style: TextStyle(
          fontSize: 15,
          color: isInteractive ? textColor : labelColor,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
        ),
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(
            fontSize: 14,
            color: _isOpen && isInteractive ? accentColor : labelColor,
            fontWeight: _isOpen && isInteractive
                ? FontWeight.w500
                : FontWeight.w400,
          ),
          floatingLabelStyle: TextStyle(
            fontSize: 12,
            color: accentColor,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: isDark ? const Color(0xFF4A4F6A) : const Color(0xFFB8BCCC),
            fontSize: 14,
          ),
          errorStyle: const TextStyle(
            color: Color(0xFFFF5C5C),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          filled: true,
          fillColor: isInteractive ? surfaceColor : disabledSurface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 17,
          ),
          // Borders
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: borderColor, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: borderColor, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: accentColor, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: disabledBorder, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFFF5C5C), width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFFF5C5C), width: 2),
          ),
        ),
        dropdownColor: isDark ? const Color(0xFF252838) : Colors.white,
        menuMaxHeight: 300,
        borderRadius: BorderRadius.circular(14),
        icon: AnimatedRotation(
          turns: _isOpen ? 0.5 : 0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: _isOpen && isInteractive
                ? accentColor
                : isInteractive
                ? (isDark ? const Color(0xFF6B72A0) : const Color(0xFF9099C0))
                : (isDark ? const Color(0xFF464A65) : const Color(0xFFBEC3D4)),
          ),
        ),
        isExpanded: true,
        selectedItemBuilder: widget.items.isEmpty
            ? null
            : (context) => widget.items
                  .map(
                    (item) => Align(
                      alignment: Alignment.centerLeft,
                      child: DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 15,
                          color: textColor,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1,
                        ),
                        child: item.child,
                      ),
                    ),
                  )
                  .toList(),
      ),
    );
  }
}
