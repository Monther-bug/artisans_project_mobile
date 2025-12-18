import 'package:artisans_project_mobile/core/constants/app_dimensions.dart';
import 'package:artisans_project_mobile/core/utils/validators.dart';

import 'package:artisans_project_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_navigation_link.dart';

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
                    child: AuthHeader(
                      title: AppLocalizations.of(context)!.createAccount,
                      subtitle: AppLocalizations.of(context)!.unlockAccess,
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
                  AuthNavigationLink(
                    text: AppLocalizations.of(context)!.alreadyHaveAccount,
                    actionText: AppLocalizations.of(context)!.login,
                    onTap: () => context.go('/login'),
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
