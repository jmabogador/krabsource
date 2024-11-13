import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krabsource/Onboarding/onboarding_view.dart';
import 'camera_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.black,
      ),
    );

    return MaterialApp(
      navigatorKey: MyPage.navigatorKey, // Assign the navigatorKey here
      debugShowCheckedModeBanner: false,
      title: 'KrabSource',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: OnboardingView(),
    );
  }
}
