import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/screens/marketplace_screen.dart';
import 'package:jeeth_app/authModule/screens/mobile_number_screen.dart';
import 'package:jeeth_app/authModule/screens/onBoarding_screen.dart';
import 'package:jeeth_app/authModule/screens/profile_document_screen.dart';
import 'package:jeeth_app/authModule/screens/splash_screen.dart';
import 'package:jeeth_app/authModule/screens/verify_otp_screen.dart';
import 'package:jeeth_app/navigation/arguments.dart';
import 'routes.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    // Auth Screens
    case NamedRoute.onBoardingScreen:
      return _getPageRoute(const OnBoardingScreen());

    case NamedRoute.mobileNumberScreen:
      return _getPageRoute(const MobileNumberScreen());

    case NamedRoute.verifyOtpScreen:
      return _getPageRoute(VerifyOtpScreen(
        args: settings.arguments as VerifyOtpArguments,
      ));

    case NamedRoute.marketPlaceScreen:
      return _getPageRoute(const MarketPlaceScreen());

    case NamedRoute.profileDocumentsScreen:
      return _getPageRoute(const ProfileDocumentsScreen());

    default:
      return _getPageRoute(const SplashScreen());
  }
}

PageRoute _getPageRoute(Widget screen) {
  return MaterialPageRoute(builder: (context) => screen);
}
