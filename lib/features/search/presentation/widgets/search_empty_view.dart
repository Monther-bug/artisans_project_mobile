import 'package:artisans_project_mobile/core/constants/app_dimensions.dart';
import 'package:artisans_project_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchEmptyView extends StatelessWidget {
  const SearchEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64.sp,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: AppDimensions.spaceMedium),
          Text(
            AppLocalizations.of(context)!.startTypingToSearch,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 16.sp),
          ),
        ],
      ),
    );
  }
}
