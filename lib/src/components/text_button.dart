import 'dart:async';
import 'package:flutter/material.dart';


class AppTextButton extends StatefulWidget {
  const AppTextButton(this.text, {
    Key? key,
    this.style,
    required this.onTap,
    this.padding
  }) : super(key: key);

  final String text;
  final TextStyle? style;
  final Function onTap;
  final EdgeInsets? padding;

  @override
  State<AppTextButton> createState() => _AppTextButtonState();
}

class _AppTextButtonState extends State<AppTextButton> {

  bool isTap = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => isTap = true),
      onTapUp: (_) {
        Timer(const Duration(milliseconds: 150), () {
          setState(() => isTap = false);
        });
      },
      onTapCancel: () {
        Timer(const Duration(milliseconds: 150), () {
          setState(() => isTap = false);
        });
      },
      onTap: () => widget.onTap(),
      child: Padding(
        padding: widget.padding ?? const EdgeInsets.all(8.0),
        child: AnimatedOpacity(
          opacity: isTap? 0.3 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Text(
            widget.text,
            style: widget.style,
          )
        ),
      ),
    );
  }
}
