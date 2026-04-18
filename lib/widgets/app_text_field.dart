import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palee_web_portfolio/utils/responsive_helper.dart';

enum DigitOnly { integer, decimal }

/// Reusable text field used across auth and contact forms
class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final String? prefixText;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final String? Function(String?)? validator;
  final bool obscureText;
  final VoidCallback? onToggleObscure;
  final DigitOnly? digitOnly;
  final List<TextInputFormatter>? inputFormatters;

  const AppTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.prefixIcon,
    this.prefixText,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.onFieldSubmitted,
    this.validator,
    this.obscureText = false,
    this.onToggleObscure,
    this.digitOnly,
    this.inputFormatters,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField>
    with SingleTickerProviderStateMixin {
  FocusNode? _internalFocusNode;
  late final AnimationController _animationController;
  late final Animation<double> _iconScaleAnimation;
  bool _isFocused = false;
  bool _hasError = false;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode!;

  @override
  void initState() {
    super.initState();
    _internalFocusNode = widget.focusNode == null ? FocusNode() : null;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _iconScaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode?.removeListener(_onFocusChange);
      if (oldWidget.focusNode == null) {
        _internalFocusNode?.removeListener(_onFocusChange);
        _internalFocusNode?.dispose();
      }

      _internalFocusNode = widget.focusNode == null ? FocusNode() : null;
      _focusNode.addListener(_onFocusChange);
      _isFocused = _focusNode.hasFocus;
    }
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
    if (_focusNode.hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _internalFocusNode?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final digitOnlyFormatters = switch (widget.digitOnly) {
      DigitOnly.integer => <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      DigitOnly.decimal => <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      null => null,
    };
    final inputFormatters = [
      ...?digitOnlyFormatters,
      ...?widget.inputFormatters,
    ];

    final labelFontSize = ResponsiveHelper.getResponsiveFontSize(
      context,
      mobile: 14,
      tablet: 15,
      desktop: 16,
    );

    // Accent color adapts to theme
    final accentColor = isDark
        ? const Color(0xFF7C9EFF)
        : const Color(0xFF3D6AFF);
    final surfaceColor = isDark
        ? const Color(0xFF1E2030)
        : const Color(0xFFFAFAFF);
    final borderColor = isDark
        ? const Color(0xFF3A3D50)
        : const Color(0xFFE2E4F0);
    final iconBgColor = isDark
        ? const Color(0xFF2A2D40)
        : const Color(0xFFEEF1FF);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: _isFocused
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
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        onFieldSubmitted: widget.onFieldSubmitted,
        inputFormatters: inputFormatters.isEmpty ? null : inputFormatters,
        obscureText: widget.obscureText,
        validator: (value) {
          final result = widget.validator?.call(value);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _hasError = result != null);
          });
          return result;
        },
        style: TextStyle(
          fontSize: labelFontSize,
          color: isDark ? const Color(0xFFE8EAFF) : const Color(0xFF1A1D2E),
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
        ),
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(
            fontSize: labelFontSize,
            color: _isFocused
                ? accentColor
                : isDark
                ? const Color(0xFF8890B0)
                : const Color(0xFF8891AA),
            fontWeight: _isFocused ? FontWeight.w500 : FontWeight.w400,
          ),
          floatingLabelStyle: TextStyle(
            fontSize: labelFontSize,
            color: _hasError ? const Color(0xFFFF5C5C) : accentColor,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: isDark ? const Color(0xFF4A4F6A) : const Color(0xFFB8BCCC),
            fontSize: labelFontSize,
          ),
          // Prefix icon with animated scale + colored background pill
          prefixIcon: widget.prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: AnimatedBuilder(
                    animation: _iconScaleAnimation,
                    builder: (context, child) => Transform.scale(
                      scale: _iconScaleAnimation.value,
                      child: child,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _isFocused
                            ? accentColor.withOpacity(0.15)
                            : iconBgColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        widget.prefixIcon,
                        size: 18,
                        color: _isFocused
                            ? accentColor
                            : isDark
                            ? const Color(0xFF6B72A0)
                            : const Color(0xFF9099C0),
                      ),
                    ),
                  ),
                )
              : null,
          prefixText: widget.prefixText,
          prefixStyle: TextStyle(
            color: accentColor,
            fontWeight: FontWeight.w600,
            fontSize: labelFontSize,
          ),
          // Visibility toggle button
          suffixIcon: widget.onToggleObscure == null
              ? null
              : IconButton(
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, anim) => ScaleTransition(
                      scale: anim,
                      child: FadeTransition(opacity: anim, child: child),
                    ),
                    child: Icon(
                      widget.obscureText
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      key: ValueKey(widget.obscureText),
                      size: 20,
                      color: _isFocused
                          ? accentColor
                          : isDark
                          ? const Color(0xFF6B72A0)
                          : const Color(0xFF9099C0),
                    ),
                  ),
                  splashRadius: 20,
                  onPressed: widget.onToggleObscure,
                ),
          filled: true,
          fillColor: surfaceColor,
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFFF5C5C), width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFFF5C5C), width: 2),
          ),
          errorStyle: const TextStyle(
            color: Color(0xFFFF5C5C),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
