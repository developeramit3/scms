import 'package:flutter/material.dart';
import 'package:scms/Utils/theme_color.dart';
import 'package:scms/services/session_repo.dart';


class ThemeNotifier with ChangeNotifier {
  final darkTheme = ThemeData(
      primarySwatch: Colors.grey,
      primaryColor: Colors.black,
      brightness: Brightness.dark,
      backgroundColor: const Color(0xFF2B2B2B),
      accentColor: Colors.black,
      accentIconTheme: IconThemeData(color: Colors.black),
      dividerColor: Colors.black12,
      selectedRowColor: const Color(0xFF52C1E2),
      appBarTheme:const AppBarTheme(
          backgroundColor:  Color(0xFF5C5C5C)
      )
  );

  final lightTheme = ThemeData(
      primarySwatch: Colors.grey,
      primaryColor: ThemeColor.colorPrimary,
      brightness: Brightness.light,
      backgroundColor: ThemeColor.colorPrimary,
      accentColor: Colors.black,
      accentIconTheme: IconThemeData(color: Colors.white),
      dividerColor: Colors.white54,
      selectedRowColor: const Color(0xFF050050),
    appBarTheme:const AppBarTheme(
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    )
  );
  ThemeData? _themeData;

  ThemeData getTheme() => _themeData==null?lightTheme:_themeData!;

  ThemeNotifier() {
    getSessionTheme().then((value) {
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
    setTheme('dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    setTheme('light');
    notifyListeners();
  }
}
