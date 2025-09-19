import 'package:daily_wellness_tracker/features/onboarding/models/onboarding_model.dart';
import 'package:flutter/material.dart';

class OnboardingViewModel extends ChangeNotifier {
  int _currentPageIndex = 0;
  bool _isLastPage = false;

  int get currentPageIndex => _currentPageIndex;
  bool get isLastPage => _isLastPage;

  List<OnboardingPageModel> get pagesContent => OnboardingData.pagesContent;

  void onPageChanged(int index) {
    _currentPageIndex = index;
    _isLastPage = _currentPageIndex == OnboardingData.pagesContent.length - 1;
    notifyListeners();
  }

  void skipOnboarding() {
    _setOnboardingCompleted();
  }

  void completeOnboarding() {
    _setOnboardingCompleted();
  }

  void _setOnboardingCompleted() {
    // TODO: Save onboarding completion status to shared preferences
    // This will prevent showing onboarding again on app restart
  }
}
