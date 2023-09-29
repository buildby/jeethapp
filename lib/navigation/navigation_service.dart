import 'package:flutter/material.dart';
import 'arguments.dart';
import 'routes.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    // Auth Screens
    case NamedRoute.onBoardingScreen:
      return _getPageRoute(const SplashScreen());

    default:
      return _getPageRoute(const SplashScreen());
  }
}

PageRoute _getPageRoute(Widget screen) {
  return MaterialPageRoute(builder: (context) => screen);
}
