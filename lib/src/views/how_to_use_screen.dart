import 'package:flutter/material.dart';

class HowToUseScreen extends StatelessWidget {
  const HowToUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0)
        )
      ),
      child: Center(
        child: Text(
          '製作中...'
        ),
      ),
    );
  }
}
