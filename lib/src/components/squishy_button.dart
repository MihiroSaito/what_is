import 'dart:async';

import 'package:flutter/material.dart';


class SquishyButton extends StatefulWidget {
  const SquishyButton({
    Key? key,
    required this.onTap,
    required this.child,
    required this.disableWidget,
    this.padding = const EdgeInsets.all(8.0)
  }) : super(key: key);

  final Function? onTap;
  final Widget child;
  final Widget disableWidget;
  final EdgeInsets padding;

  @override
  State<SquishyButton> createState() => _SquishyButtonState();
}

class _SquishyButtonState extends State<SquishyButton> {

  bool isTap = false;

  @override
  Widget build(BuildContext context) {

    if (widget.onTap == null) {
      return widget.disableWidget;
    }

    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => isTap = true),
        onTapUp: (_) => setState(() => isTap = false),
        onTapCancel: () {
          Timer(const Duration(milliseconds: 110), () {
            setState(() => isTap = false);
          });
        },
        onTap: widget.onTap != null
            ? () => widget.onTap!()
            : null,
        child: AnimatedOpacity(
          opacity: isTap? 0.5 : 1.0,
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 100),
          child: AnimatedScale(
              scale: isTap? 0.9 : 1.0,
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 100),
              child: Padding(
                padding: widget.padding,
                child: widget.child,
              )
          ),
        )
    );
  }
}
