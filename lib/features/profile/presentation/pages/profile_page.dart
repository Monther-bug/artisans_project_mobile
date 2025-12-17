import 'package:artisans_project_mobile/core/constants/app_dimensions.dart';
import 'package:artisans_project_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:artisans_project_mobile/features/profile/presentation/widgets/logout_dialog.dart';
import 'package:artisans_project_mobile/features/profile/presentation/widgets/profile_header.dart';
import 'package:artisans_project_mobile/features/profile/presentation/widgets/profile_menu_item.dart';
import 'package:artisans_project_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:artisans_project_mobile/shared/theme/theme_provider.dart';
import 'package:artisans_project_mobile/shared/providers/locale_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
              color: Colors.black,
            ),
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          children: [
            SizedBox(height: AppDimensions.spaceMedium),
            ProfileHeader(user: user),
            SizedBox(height: AppDimensions.spaceXLarge),
            ProfileMenuItem(
              icon: Icons.person_outline,
              title: localization.editProfile,
              onTap: () {},
            ),
            ProfileMenuItem(
              icon: Icons.notifications_outlined,
              title: localization.notifications,
              onTap: () {},
            ),
            ProfileMenuItem(
              icon: Icons.lock_outline,
              title: localization.privacySecurity,
              onTap: () {},
            ),
            ProfileMenuItem(
              icon: Icons.help_outline,
              title: localization.helpSupport,
              onTap: () {},
            ),
            ProfileMenuItem(
              icon: Icons.language,
              title: 'Language (English / العربية)',
              onTap: () {
                ref.read(localeProvider.notifier).toggleLocale();
              },
            ),
            SizedBox(height: AppDimensions.spaceLarge),
            ProfileMenuItem(
              icon: Icons.logout,
              title: 'Logout',
              isDestructive: true,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => LogoutDialog(
                    onConfirm: () {
                      ref.read(authNotifierProvider.notifier).signOut();
                      context.go('/login');
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
