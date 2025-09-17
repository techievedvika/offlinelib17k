import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lib17000ft/configs/color/color.dart';
import 'package:lib17000ft/services/splash_services.dart';
import 'package:flutter/animation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
    with SingleTickerProviderStateMixin {
  late final SplashServices _splashServices;
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _textSpacingAnimation;
  late final Animation<Color?> _colorAnimation;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _splashServices = SplashServices();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Initialize animations
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _textSpacingAnimation = Tween<double>(begin: 0, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _colorAnimation = ColorTween(
      begin: AppColors.primary.withOpacity(0.5),
      end: AppColors.primary,
    ).animate(_controller);

    // Start animation
    _controller.forward().then((_) {
      if (!_disposed) {
        _splashServices.isLogin(context);
      }
    });
  }

  @override
  void dispose() {
    _disposed = true;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              _colorAnimation.value ?? AppColors.primary,
              (_colorAnimation.value ?? AppColors.primary).withOpacity(0.9),
              (_colorAnimation.value ?? AppColors.primary).withOpacity(0.8),
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logo.png',width: 200,height: 200,),
                  // Icon(
                  //   Icons.landscape_outlined,
                  //   size: isSmallScreen ? 80 : 120,
                  //   color: AppColors.onPrimary,
                  // ),
                  const SizedBox(height: 30),
                  AnimatedBuilder(
                    animation: _textSpacingAnimation,
                    builder: (context, child) {
                      return Column(
                        children: [
                          Text(
                            '17000ft',
                            style: GoogleFonts.poppins(
                              fontSize: isSmallScreen ? 32 : 48,
                              fontWeight: FontWeight.w800,
                              color: AppColors.onPrimary,
                              letterSpacing: _textSpacingAnimation.value,
                            ),
                          ),
                          Text(
                            'LIBRARY',
                            style: GoogleFonts.poppins(
                              fontSize: isSmallScreen ? 24 : 36,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onPrimary.withOpacity(0.8),
                              letterSpacing: _textSpacingAnimation.value,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}