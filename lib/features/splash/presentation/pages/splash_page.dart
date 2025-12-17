import 'package:artisans_project_mobile/features/splash/presentation/widgets/splash_logo.dart';
import 'package:artisans_project_mobile/features/splash/presentation/widgets/splash_title.dart';
import 'package:artisans_project_mobile/features/splash/presentation/providers/splash_controller.dart';
import 'package:artisans_project_mobile/shared/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:artisans_project_mobile/core/constants/app_dimensions.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(splashControllerProvider, (previous, next) {
      next.when(
        data: (state) {
          if (state == SplashState.authenticated) {
            context.go('/');
          } else if (state == SplashState.unauthenticated) {
            context.go('/login');
          }
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Startup Error: $error'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 10),
            ),
          );
        },
        loading: () {},
      );
    });

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SplashLogo(),
                SizedBox(height: AppDimensions.spaceLarge),
                const SplashTitle(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
