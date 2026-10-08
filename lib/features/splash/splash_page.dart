import 'dart:async';

import 'package:flutter/material.dart';

import 'package:preproject_books/widgets/splash_widgets.dart';
import 'package:preproject_books/features/home/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );

    animation = CurvedAnimation(parent: controller, curve: Curves.easeOut);

    controller.forward();

    Timer(const Duration(seconds: 3), () {
      if (!mounted) {
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SplashContent(animation: animation));
  }
}
