import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack),
    );

    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeIn),
    );

    _ctrl.forward();

    // after splash, navigate to login (or home) - change duration as needed
    Timer(const Duration(milliseconds: 1800), () {
      // if you want to go to login first:
      Navigator.of(context).pushReplacementNamed('/login');
      // or go directly to home: Navigator.of(context).pushReplacementNamed('/home');
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // safe fallback in case asset is not available
    const String assetPath = 'assets/images/bhejdu_logo.png';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // try to load the logo image, fallback to text if missing
                SizedBox(
                  width: 220,
                  height: 220,
                  child: Image.asset(
                    assetPath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // fallback minimal logo build
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.shopping_cart_outlined,
                              size: 72, color: Color(0xFF0A5DB6)),
                          SizedBox(height: 12),
                          Text(
                            'Bhejdu',
                            style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0A5DB6)),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'BEYOND INSTANT — PERFECTLY TIMED',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF43C268)),
                          ),
                        ],
                      );
                    },
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
