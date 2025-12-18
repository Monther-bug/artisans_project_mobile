import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/providers/locale_provider.dart';

class LanguageSelectorSheet extends ConsumerWidget {
  const LanguageSelectorSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: AppDimensions.paddingMedium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: AppDimensions.spaceMedium),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: AppDimensions.spaceMedium),
            Text(
              'Select Language',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: AppDimensions.spaceMedium),
            ListTile(
              leading: Text('🇺🇸', style: TextStyle(fontSize: 24.sp)),
              title: Text('English', style: TextStyle(fontSize: 16.sp)),
              trailing: currentLocale.languageCode == 'en'
                  ? Icon(Icons.check, color: Colors.blue, size: 24.sp)
                  : null,
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Text('🇸🇦', style: TextStyle(fontSize: 24.sp)),
              title: Text('العربية', style: TextStyle(fontSize: 16.sp)),
              trailing: currentLocale.languageCode == 'ar'
                  ? Icon(Icons.check, color: Colors.blue, size: 24.sp)
                  : null,
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(const Locale('ar'));
                Navigator.pop(context);
              },
            ),
            SizedBox(height: AppDimensions.spaceMedium),
          ],
        ),
      ),
    );
  }

  static void show(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => const LanguageSelectorSheet(),
    );
  }
}
