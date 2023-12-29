import 'package:flutter/material.dart';

enum AppAnimationType {
  fadeIn,
  scale
}

class AppAnimation extends StatefulWidget {
  const AppAnimation.fadeIn({
    required this.child,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeIn,
    Key? key}): type = AppAnimationType.fadeIn, super(key: key, );

  const AppAnimation.scale({
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOutBack,
    Key? key}): type = AppAnimationType.scale, super(key: key);

  final Widget child;
  final AppAnimationType type;
  final Duration duration;
  final Curve curve;

  @override
  State<AppAnimation> createState() => _AppAnimationState();
}

class _AppAnimationState extends State<AppAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration, // アニメーションの時間
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: widget.curve,
    );

    _animationController.forward(); // アニメーションを開始
  }

  @override
  void dispose() {
    _animationController.dispose(); // アニメーションコントローラーを解放
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == AppAnimationType.fadeIn) {
      return FadeTransition(
        opacity: _animation, // フェードインアニメーションを適用するアニメーションオブジェクト
        child: widget.child,
      );
    } else {
      return ScaleTransition(
        scale: _animation, // スケールアニメーションを適用するアニメーションオブジェクト
        child: widget.child,
      );
    }
  }
}
