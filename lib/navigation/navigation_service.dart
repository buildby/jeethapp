import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/screens/explore_deal_screen.dart';
import 'package:jeeth_app/authModule/screens/marketplace_screen.dart';
import 'package:jeeth_app/authModule/screens/mobile_number_screen.dart';
import 'package:jeeth_app/authModule/screens/onBoarding_screen.dart';
import 'package:jeeth_app/authModule/screens/profile_document_screen.dart';
import 'package:jeeth_app/authModule/screens/splash_screen.dart';
import 'package:jeeth_app/authModule/screens/verify_otp_screen.dart';
import 'package:jeeth_app/common_widgets/bottom_nav_bar.dart';
import 'package:jeeth_app/homeModule/screens/earning_screen.dart';
import 'package:jeeth_app/homeModule/screens/notifications_screen.dart';
import 'package:jeeth_app/homeModule/screens/refer_friend_screen.dart';
import 'package:jeeth_app/homeModule/screens/settings_screen.dart';
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
      return _getPageRoute(MarketPlaceScreen(
          // args: settings.arguments as MarketPlaceScreenArguments,
          ));

    case NamedRoute.profileDocumentsScreen:
      return _getPageRoute(const ProfileDocumentsScreen());

    case NamedRoute.exploreDealScreen:
      return _getPageRoute(ExploreDealScreen(
        args: settings.arguments as ExploreDealScreenArguments,
      ));

    case NamedRoute.bottomNavBarScreen:
      return _getPageRoute(BottomNavBar(
        args: settings.arguments as BottomNavArguments,
      ));

    case NamedRoute.earningsScreen:
      return _getPageRoute(const EarningsScreen());

    case NamedRoute.settingsScreen:
      return _getPageRoute(const SettingsScreen());

    case NamedRoute.notificationsScreen:
      return _getPageRoute(const NotificationsScreen());

    case NamedRoute.referAFriendScreen:
      return _getPageRoute(const ReferAFriendScreen());

    default:
      return _getPageRoute(const SplashScreen());
  }
}

PageRoute _getPageRoute(Widget screen) {
  return MaterialPageRoute(builder: (context) => screen);
}
