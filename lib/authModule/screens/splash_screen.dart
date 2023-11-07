// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jeeth_app/common_widgets/circular_loader.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import '../../navigation/arguments.dart';
import '../../navigation/navigators.dart';
import '../../navigation/routes.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final LocalStorage storage = LocalStorage('jeeth_app');
  bool isLoggedOut = true;
  bool isFetchingFleetData = true;
  bool isLoading = false;
  bool locationLoading = false;

  var referralCode = '';
  var referredByUserId = '';

  Map language = {};

  Map? fleetData;

  // checkAndGetLocationPermission() async {
  //   setState(() => locationLoading = true);
  //   try {
  //     await handlePermissionsFunction();
  //     if (await Permission.location.isGranted) {
  //       final _authProvider = Provider.of<AuthProvider>(context, listen: false);
  //       await _authProvider.fetchMyLocation();
  //       final coord = _authProvider.user.coordinates;
  //       if (coord != null) {
  //         final User user =
  //             Provider.of<AuthProvider>(context, listen: false).user;
  //         String coordString = [coord.longitude, coord.latitude].toString();
  //         final response =
  //             await Provider.of<CafeProvider>(context, listen: false).fetchCafe(
  //                 accessToken: user.accessToken,
  //                 query: 'coordinates=$coordString');
  //         if (response['success']) {
  //           pushAndRemoveUntil(NamedRoute.bottomNavBarScreen,
  //               arguments: BottomNavArgumnets());
  //           if (!user.isLocationAllowed) {
  //             Provider.of<AuthProvider>(context, listen: false)
  //                 .editProfile(body: {'isLocationAllowed': 'true'}, files: {});
  //           }
  //         } else {
  //           push(NamedRoute.locationScreen);
  //         }
  //       } else {
  //         push(NamedRoute.locationScreen);
  //       }
  //     } else {
  //       showSnackbar('Please enable location access');
  //       return;
  //     }
  //     //
  //   } catch (e) {
  //     showSnackbar('Please enable location access');
  //   } finally {
  //     setState(() => locationLoading = false);
  //   }
  // }

  goToSelectLanguageScreen() {
    pushAndRemoveUntil(NamedRoute.selectLanguageScreen,
        arguments: const SelectLanguageScreenArguments(fromOnboarding: true));
    // Future.delayed(
    //     const Duration(seconds: 2, milliseconds: 5),
    //     () => pushAndRemoveUntil(NamedRoute.loginScreen,
    //         arguments: LoginSceenArguments()));
  }

  goToOnBoardingScreen() {
    Future.delayed(
        const Duration(
          seconds: 2,
        ),
        () => pushReplacement(NamedRoute.onBoardingScreen,
            arguments:
                const SelectLanguageScreenArguments(fromOnboarding: true)));
  }

  tryAutoLogin() async {
    try {
      var authProvider = Provider.of<AuthProvider>(context, listen: false);

      await storage.ready;
      final accessTokenString = storage.getItem('accessToken');
      final Map languageResponse = {'success': true};
      // final  languageResponse = await getLanguage();

      if (accessTokenString != null) {
        var accessToken = json.decode(accessTokenString);
        if (accessToken != null) {
          final loginResponse =
              await authProvider.driverAutoLogin(phone: accessToken['phone']);

          if (loginResponse['result'] == 'success' &&
              loginResponse['data']['user'] != null &&
              languageResponse['success']) {
            final user = Provider.of<AuthProvider>(context, listen: false).user;
            Future.delayed(
                const Duration(seconds: 2),
                () => pushAndRemoveUntil(NamedRoute.bottomNavBarScreen,
                    arguments: BottomNavArguments()));
          } else {
            goToOnBoardingScreen();
          }
        } else {
          goToOnBoardingScreen();
        }
      } else {
        goToOnBoardingScreen();
      }
    } catch (e) {
      goToSelectLanguageScreen();
    }
  }

  getLanguage() async {
    await storage.ready;
    var languageMap = storage.getItem('language');
    String language = 'english';

    if (languageMap != null) {
      languageMap = json.decode(languageMap);
      language = languageMap['language'];
    } else {
      Provider.of<AuthProvider>(context, listen: false)
          .setLanguageInStorage(language);
    }

    final response = await Provider.of<AuthProvider>(context, listen: false)
        .getAppConfig(['user-$language', 'delete_feature']);

    return response;
  }

  getAppConfigs() {
    Provider.of<AuthProvider>(context, listen: false)
        .getAppConfig(['helpAndSuppWhatsApp', 'Razorpay']);
  }

  myInit() async {
    await tryAutoLogin();
    getAppConfigs();
  }

  @override
  void initState() {
    super.initState();

    myInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double dW = MediaQuery.of(context).size.width;
    final double dH = MediaQuery.of(context).size.height;
    // final double tS = MediaQuery.of(context).textScaleFactor;
    // final language = Provider.of<AuthProvider>(context).selectedLanguage;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/images/splash_logo.png',
              width: dW,
              scale: 2,
            ),
          ),
          if (locationLoading)
            Positioned(
                left: 0,
                right: 0,
                bottom: dH * 0.3,
                child: const CircularLoader())
        ],
      ),
    );
  }
}
