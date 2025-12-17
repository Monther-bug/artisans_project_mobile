import 'package:artisans_project_mobile/core/constants/app_dimensions.dart';
import 'package:artisans_project_mobile/core/utils/validators.dart';
import 'package:artisans_project_mobile/shared/theme/app_theme.dart';
import 'package:artisans_project_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/google_button.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../providers/auth_provider.dart';

import 'package:artisans_project_mobile/core/constants/app_images.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(authNotifierProvider.notifier)
          .login(_emailController.text.trim(), _passwordController.text.trim());
      // Success check is done via listener or simple error check
      if (ref.read(authNotifierProvider).user != null) {
        if (mounted) context.go('/'); // Navigate to Home
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    // Listen to errors
    ref.listen(authNotifierProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.paddingLarge),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(AppDimensions.paddingSmall / 2),
                        child: ClipOval(
                          child: Image.asset(
                            AppImages.logo,
                            height: AppDimensions.logoSizeLarge,
                            width: AppDimensions.logoSizeLarge,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: AppDimensions.spaceXLarge),
                    Text(
                      AppLocalizations.of(context)!.welcomeBack,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                    ),

                    SizedBox(height: AppDimensions.spaceXLarge),
                    CustomTextField(
                      controller: _emailController,
                      hintText: AppLocalizations.of(context)!.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: AppValidators.validateEmail,
                    ),
                    SizedBox(height: AppDimensions.spaceMedium),
                    CustomTextField(
                      controller: _passwordController,
                      hintText: AppLocalizations.of(context)!.password,
                      isPassword: true,
                      validator: AppValidators.validatePassword,
                    ),
                    SizedBox(height: AppDimensions.spaceLarge),
                    PrimaryButton(
                      text: AppLocalizations.of(context)!.login,
                      onPressed: _login,
                      isLoading: authState.isLoading,
                    ),
                    SizedBox(height: AppDimensions.spaceMedium),
                    const Divider(),
                    SizedBox(height: AppDimensions.spaceMedium),
                    GoogleButton(
                      isLoading: authState.isLoading,
                      onPressed: () async {
                        await ref
                            .read(authNotifierProvider.notifier)
                            .signInWithGoogle();
                        if (ref.read(authNotifierProvider).user != null) {
                          if (mounted) context.go('/');
                        }
                      },
                    ),
                    SizedBox(height: AppDimensions.spaceLarge),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppLocalizations.of(context)!.dontHaveAccount),
                        TextButton(
                          onPressed: () => context.push('/register'),
                          child: Text(
                            AppLocalizations.of(context)!.register,
                            style: const TextStyle(
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
