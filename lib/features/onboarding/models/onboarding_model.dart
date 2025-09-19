class OnboardingPageModel {
  final String title;
  final String subtitle;
  final String imagePath;
  final String description;

  OnboardingPageModel({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.description,
  });
}

class OnboardingData {
  static final List<OnboardingPageModel> pagesContent = [
    OnboardingPageModel(
      title: "Welcome to Daily Wellness",
      subtitle: "Track your health journey",
      imagePath: "assets/images/welcome.png",
      description:
          "Your personal companion for monitoring daily calorie intake and water consumption to maintain a healthy lifestyle.",
    ),
    OnboardingPageModel(
      title: "Track Your Calories",
      subtitle: "Monitor your daily intake",
      imagePath: "assets/images/calories.png",
      description:
          "Easily log your meals and track your daily calorie consumption to reach your health goals.",
    ),
    OnboardingPageModel(
      title: "Stay Hydrated",
      subtitle: "Monitor water intake",
      imagePath: "assets/images/water.png",
      description:
          "Keep track of your water consumption throughout the day and stay properly hydrated.",
    ),
    OnboardingPageModel(
      title: "View Your Progress",
      subtitle: "Check your history",
      imagePath: "assets/images/history.png",
      description:
          "Review your daily progress and see your wellness journey over the past 3 days.",
    ),
  ];
}
