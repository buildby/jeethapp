// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import 'auth_module/providers/auth_provider.dart';
import 'navigation/navigation_service.dart';
import 'navigation/navigators.dart';
import 'theme_manager.dart';

final LocalStorage storage = LocalStorage('re_household');

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Future<void> backgroundHandler(RemoteMessage message) async {}

awaitStorageReady() async {
  await storage.ready;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
