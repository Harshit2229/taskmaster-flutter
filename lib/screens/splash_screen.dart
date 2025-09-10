import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_sizes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _fadeController;
  
  late Animation<double> _logoScale;
  late Animation<double> _logoRotation;
  late Animation<double> _textSlide;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: AppSizes.animationDurationSplash),
      vsync: this,
    );
    
    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: AppSizes.animationDurationVerySlow + 500),
      vsync: this,
    );
    
    // Fade animation controller
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: AppSizes.animationDurationVerySlow),
      vsync: this,
    );

    // Logo scale animation
    _logoScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    // Logo rotation animation
    _logoRotation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeInOut,
    ));

    // Text slide animation
    _textSlide = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutBack,
    ));

    // Fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    _startAnimations();
  }

  void _startAnimations() async {
    await _logoController.forward();
    await _textController.forward();
    await _fadeController.forward();
    
    // Wait a bit then navigate
    await Future.delayed(const Duration(milliseconds: AppSizes.animationDurationVerySlow));
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: AppSizes.animationDurationSplash - 1200),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Logo
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoScale.value,
                      child: Transform.rotate(
                        angle: _logoRotation.value * 2 * 3.14159,
                        child: Container(
                          width: AppSizes.splashLogoSize,
                          height: AppSizes.splashLogoSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.cardGradient,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadowMedium,
                                blurRadius: AppSizes.shadowBlurRadiusLarge,
                                offset: const Offset(AppSizes.shadowOffsetX, AppSizes.shadowOffsetYLarge),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.checklist_rounded,
                            size: AppSizes.splashIconSize,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: AppSizes.spacing40),
                
                // Animated App Name
                AnimatedBuilder(
                  animation: _textController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _textSlide.value),
                      child: const Text(
                        'TaskMaster',
                        style: AppTextStyles.splashTitle,
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: AppSizes.spacing10),
                
                // Animated Subtitle
                AnimatedBuilder(
                  animation: _fadeController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: const Text(
                        'Organize Your Life',
                        style: AppTextStyles.splashSubtitle,
                      ),
                    );
                  },
                ),
                
                SizedBox(height: AppSizes.spacing60),
                
                // Loading indicator
                AnimatedBuilder(
                  animation: _fadeController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: SizedBox(
                        width: AppSizes.splashProgressSize,
                        height: AppSizes.splashProgressSize,
                        child: const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                          strokeWidth: 3,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
