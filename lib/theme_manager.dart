import 'package:flutter/material.dart';
import 'storage_manager.dart';

// 'Outfit'

class ThemeNotifier with ChangeNotifier {
//
  final lightTheme = ThemeData(
    primaryColor: const Color(0xFF0197FC),
    brightness: Brightness.light,
    fontFamily: 'Inter',
    backgroundColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    dividerColor: Colors.white54,
    disabledColor: Colors.purple[300],
    textTheme: const TextTheme(
      headline1: TextStyle(fontWeight: FontWeight.w600),
      headline2: TextStyle(fontWeight: FontWeight.w500),
      headline3: TextStyle(fontWeight: FontWeight.w400),
      headline4: TextStyle(fontFamily: 'Inria Serif', fontWeight: FontWeight.w400)
    ),
  );

  final darkTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    fontFamily: 'Outfit',
    backgroundColor: const Color(0xFF212121),
    disabledColor: Colors.purple[300],
    dividerColor: Colors.black12,
    textTheme: const TextTheme(),
  );

  ThemeData? _themeData;
  ThemeData? getTheme() => _themeData;

  ThemeNotifier() {
    StorageManager.readData('themeMode').then((value) {
      print('value read from storage: ' + value.toString());
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        _themeData = lightTheme;
      } else {
        print('setting dark theme');
        _themeData = darkTheme;
      }
      notifyListeners();
    });
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }
}
