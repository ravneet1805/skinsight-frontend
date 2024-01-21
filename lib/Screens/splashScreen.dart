import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skinsight/AuthScreens/loginScreen.dart';
import 'package:skinsight/Screens/home.dart';
import 'package:skinsight/utils/constant.dart';







class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Widget nextScreen = HomeScreen();
  @override
  void initState() {
    super.initState();
    navigateToNextScreen();
  }

  Future<void> navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2)); // Change the duration as needed

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getString('user_token') != null;

    Widget nextScreen;
    if (isLoggedIn) {
      nextScreen = HomeScreen();
    } else {
      nextScreen = LoginScreen();
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: AnimatedSplashScreen(
          disableNavigation: true,
          centered: true,
            //duration: 2000,
            splash: Image.asset('assets/icons/logo.png'),
                    splashIconSize: 300,
            nextScreen: Container(),
            // splashTransition: SplashTransition.fadeTransition,
            // pageTransitionType: PageTransitionType.leftToRight,
            backgroundColor: kLightGreencolor));
  }
}