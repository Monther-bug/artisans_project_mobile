import 'package:artisans_project_mobile/core/constants/app_dimensions.dart';
import 'package:artisans_project_mobile/features/search/presentation/widgets/search_empty_view.dart';
import 'package:artisans_project_mobile/features/search/presentation/widgets/search_input.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Search',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          children: [
            const SearchInput(
              hintText: 'What are you looking for?',
              // TODO: Add controller and onChanged when implementing logic
            ),
            SizedBox(height: AppDimensions.spaceXLarge),
            const Expanded(child: SearchEmptyView()),
          ],
        ),
      ),
    );
  }
}
