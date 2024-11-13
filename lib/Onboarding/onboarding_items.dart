import 'onboarding_info.dart';

class OnboardingItems {
  List<OnboardingInfo> items = [
    OnboardingInfo(
        title: "Dashboard",
        descriptions:
            "The dashboard highlighting key characteristics of crab species, offering quick insights into their habitat and color. Alongside this, an interactive map shows the locations where each crab species is commonly found.",
        image: "assets/dashboard.png"),
    OnboardingInfo(
        title: "Camera",
        descriptions:
            "On the camera page, you can pick or upload a photo of a crab, which the system will analyze to identify the species.",
        image: "assets/camera.png"),
    OnboardingInfo(
        title: "Classification Result",
        descriptions:
            "The display page showcases the results of the crab classification, featuring the local, English, scientific names of the species, along with details about its characteristics.",
        image: "assets/display.png"),
    OnboardingInfo(
        title: "About",
        descriptions:
            "On the about page, it shows the information of the application and the team behind it.",
        image: "assets/about.png"),
    OnboardingInfo(image: "assets/KrabSource.png", title: "", descriptions: ""),
  ];
}
