import 'package:daily_wellness_tracker/core/routes/navigation_controller.dart';
import 'package:daily_wellness_tracker/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daily_wellness_tracker/features/onboarding/presentation/viewModel/onboarding_view_model.dart';
import 'package:daily_wellness_tracker/features/onboarding/presentation/view/widgets/onborading_content_widget.dart';
import 'package:daily_wellness_tracker/features/home/routes/home_pages.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage(OnboardingViewModel viewModel) {
    if (viewModel.currentPageIndex < viewModel.pagesContent.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  _completeOnboarding(OnboardingViewModel viewModel) {
    context.read<NavigationController>().removeUntil(routeName: HomePages.home);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Consumer<OnboardingViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (!viewModel.isLastPage)
                          TextButton(
                            onPressed: () => _completeOnboarding(viewModel),
                            child: const Text(
                              'Skip',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: viewModel.onPageChanged,
                      itemCount: viewModel.pagesContent.length,
                      itemBuilder: (context, index) {
                        return OnboardingContentWidget(
                          pageData: viewModel.pagesContent[index],
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        viewModel.pagesContent.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: viewModel.currentPageIndex == index ? 24 : 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: viewModel.currentPageIndex == index
                                ? AppColors.primaryLight
                                : Colors.grey[300],
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 24.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (viewModel.currentPageIndex > 0)
                          TextButton(
                            onPressed: _previousPage,
                            child: const Text(
                              'Previous',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          )
                        else
                          const SizedBox(width: 80),

                        ElevatedButton(
                          onPressed: viewModel.isLastPage
                              ? () => _completeOnboarding(viewModel)
                              : () => _nextPage(viewModel),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            viewModel.isLastPage ? 'Get Started' : 'Next',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
