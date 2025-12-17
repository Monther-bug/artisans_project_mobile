import 'package:artisans_project_mobile/core/constants/app_dimensions.dart';
import 'package:artisans_project_mobile/core/constants/app_images.dart';
import 'package:artisans_project_mobile/core/utils/validators.dart';
import 'package:artisans_project_mobile/shared/theme/app_theme.dart';
import 'package:artisans_project_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../providers/auth_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.passwordsDoNotMatch),
          ),
        );
        return;
      }

      await ref
          .read(authNotifierProvider.notifier)
          .register(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );

      if (ref.read(authNotifierProvider).user != null) {
        if (mounted) context.go('/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

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
          padding: EdgeInsets.all(AppDimensions.paddingMedium),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: AppDimensions.spaceMedium),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(AppDimensions.paddingSmall),
                      child: ClipOval(
                        child: Image.asset(
                          AppImages.logo,
                          height: AppDimensions.logoSizeSmall,
                          width: AppDimensions.logoSizeSmall,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppDimensions.spaceLarge),
                  SizedBox(height: AppDimensions.spaceLarge),
                  Text(
                    AppLocalizations.of(context)!.createAccount,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: AppDimensions.spaceSmall),
                  Text(
                    AppLocalizations.of(context)!.unlockAccess,
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
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
                  SizedBox(height: AppDimensions.spaceMedium),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    hintText: AppLocalizations.of(context)!.confirmPassword,
                    isPassword: true,
                    validator: (value) => AppValidators.validateConfirmPassword(
                      value,
                      _passwordController.text,
                    ),
                  ),
                  SizedBox(height: AppDimensions.spaceLarge),
                  PrimaryButton(
                    text: AppLocalizations.of(context)!.register,
                    onPressed: _register,
                    isLoading: authState.isLoading,
                  ),
                  SizedBox(height: AppDimensions.spaceLarge),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context)!.alreadyHaveAccount),
                      TextButton(
                        onPressed: () => context.go('/login'),
                        child: Text(
                          AppLocalizations.of(context)!.login,
                          style: const TextStyle(color: AppTheme.primaryColor),
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
    );
  }
}
