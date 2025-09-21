import 'package:daily_wellness_tracker/features/onboarding/data/models/onboarding_model.dart';
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
}
