// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/authModule/providers/driver_details_provider.dart';
import 'package:jeeth_app/authModule/providers/marketplace_provider.dart';
import 'package:jeeth_app/authModule/screens/splash_screen.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import 'navigation/navigation_service.dart';
import 'theme_manager.dart';

final LocalStorage storage = LocalStorage('jeeth_app');

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Future<void> backgroundHandler(RemoteMessage message) async {}

awaitStorageReady() async {
  await storage.ready;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  return runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  myInit() async {}

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    myInit();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MarketplaceProvider()),
        ChangeNotifierProvider(create: (_) => DriverDetailsProvider()),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
            navigatorKey: navigatorKey,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: child!,
              );
            },
            title: 'Recyclink',
            theme: theme.getTheme(),
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            onGenerateRoute: generateRoute,
            routes: {
              '/': (BuildContext context) => const SplashScreen(),
              // '/': (BuildContext context) =>
              //     HomeScreen(args: HomeScreenArguments()),
            }),
      ),
    );
  }
}
