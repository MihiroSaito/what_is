import 'package:flutter/material.dart';

class AppFadeAnimate extends StatefulWidget {
  const AppFadeAnimate({
    required this.child,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeIn,
  Key? key}) : super(key: key);

  final Widget child;
  final Duration duration;
  final Curve curve;

  @override
  State<AppFadeAnimate> createState() => _AppFadeAnimateState();
}

class _AppFadeAnimateState extends State<AppFadeAnimate> with SingleTickerProviderStateMixin {
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
    return FadeTransition(
      opacity: _animation, // フェードインアニメーションを適用するアニメーションオブジェクト
      child: widget.child,
    );
  }
}
