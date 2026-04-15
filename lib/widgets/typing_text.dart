import 'package:flutter/material.dart';
import 'package:palee_web_portfolio/widgets/gradient_text.dart';

/// Widget that displays text with a typing animation effect
class TypingText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final Gradient? gradient;
  final Duration speed;
  final Duration pause;

  const TypingText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.gradient,
    this.speed = const Duration(milliseconds: 50),
    this.pause = const Duration(milliseconds: 1000),
  });

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  String _displayText = '';
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() async {
    await Future.delayed(widget.pause);
    for (int i = 0; i <= widget.text.length; i++) {
      if (mounted) {
        setState(() {
          _displayText = widget.text.substring(0, i);
          _isComplete = i == widget.text.length;
        });
        await Future.delayed(widget.speed);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayText = _isComplete ? _displayText : '$_displayText|';

    if (widget.gradient != null) {
      return GradientText(
        text: displayText,
        gradient: widget.gradient!,
        style: widget.style,
        textAlign: widget.textAlign,
      );
    }

    return Text(displayText, style: widget.style, textAlign: widget.textAlign);
  }
}
