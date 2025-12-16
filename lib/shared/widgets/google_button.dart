import 'package:artisans_project_mobile/core/constants/app_dimensions.dart';
import 'package:artisans_project_mobile/shared/theme/app_theme.dart';
import 'package:flutter/material.dart';

class GoogleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const GoogleButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimensions.buttonHeight,
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          ),
          padding: const EdgeInsets.symmetric(vertical: 0),
        ),
        icon: Icon(
          Icons.g_mobiledata,
          color: AppTheme.primaryColor,
          size: AppDimensions.iconSizeLarge,
        ),
        label: const Text(
          'Sign in with Google',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryColor,
          ),
        ),
      ),
    );
  }
}
