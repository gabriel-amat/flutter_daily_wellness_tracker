import 'package:daily_wellness_tracker/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:daily_wellness_tracker/features/onboarding/models/onboarding_model.dart';

class OnboardingContentWidget extends StatelessWidget {
  final OnboardingPageModel pageData;

  const OnboardingContentWidget({super.key, required this.pageData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16,
        children: [
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(_getIconForPage(), size: 80, color: AppColors.primary),
          ),
          Text(
            pageData.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            pageData.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryLight,
            ),
          ),
          Text(
            pageData.description,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  IconData _getIconForPage() {
    if (pageData.title.contains('Welcome')) {
      return Icons.favorite;
    } else if (pageData.title.contains('Calories')) {
      return Icons.restaurant;
    } else if (pageData.title.contains('Hydrated')) {
      return Icons.water_drop;
    } else if (pageData.title.contains('Progress')) {
      return Icons.analytics;
    }
    return Icons.health_and_safety;
  }
}
