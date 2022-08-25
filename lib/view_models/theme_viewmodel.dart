import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/color_extension.dart';

Color kPrimaryColor = ColorExtension.hexToColor('#9087E5');
Color kSecondaryColor = ColorExtension.hexToColor('#D5D6EF');
Color kSelectedColor = ColorExtension.hexToColor('#FF8FA2');
Color kHawkBlueColor = ColorExtension.hexToColor('#C4D0FB');
Color kDarkPrimaryColor = ColorExtension.hexToColor('#02066F');
Color kDarkSecondaryColor = ColorExtension.hexToColor('#4B4466');
Color kDarkSelectedColor = ColorExtension.hexToColor('#894F5D');
Color kQuizGameUnselectedColor = ColorExtension.hexToColor('#EFEEFC');

class ThemeManager extends ChangeNotifier {
  late ThemeData _selectedTheme;
  late bool _isDark;

  Future<void> swapTheme(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value == true) {
      _isDark = true;
      _selectedTheme = dark();
      prefs.setBool('isDarkTheme', true);
    } else {
      _isDark = false;
      _selectedTheme = light();
      prefs.setBool('isDarkTheme', false);
    }
    notifyListeners();
  }

  ThemeManager({required bool isDarkMode}) {
    if (isDarkMode) {
      _isDark = true;
      _selectedTheme = dark();
    } else {
      _isDark = false;
      _selectedTheme = light();
    }
  }

  bool get getDarkMode => _isDark;
  ThemeData get getTheme => _selectedTheme;
  static TextTheme lightTextTheme = TextTheme(
    headline1: GoogleFonts.rubik(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    headline2: GoogleFonts.rubik(
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    headline3: GoogleFonts.rubik(
      fontSize: 24.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    headline4: GoogleFonts.rubik(
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    headline5: GoogleFonts.rubik(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    headline6: GoogleFonts.rubik(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    headline1: GoogleFonts.rubik(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headline2: GoogleFonts.rubik(
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headline3: GoogleFonts.rubik(
      fontSize: 24.0,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    headline4: GoogleFonts.rubik(
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    headline5: GoogleFonts.rubik(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    headline6: GoogleFonts.rubik(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
  );

  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateColor.resolveWith((states) {
          return kPrimaryColor;
        }),
      ),
      appBarTheme: AppBarTheme(
        foregroundColor: Colors.white,
        backgroundColor: kPrimaryColor,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: kPrimaryColor,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Colors.white,
        backgroundColor: kPrimaryColor,
        unselectedItemColor: kSecondaryColor,
      ),
      textTheme: lightTextTheme,
      primaryColor: kPrimaryColor,
      secondaryHeaderColor: kSecondaryColor,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateColor.resolveWith((states) {
          return kPrimaryColor;
        }),
      ),
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(
        foregroundColor: Colors.white,
        backgroundColor: kDarkPrimaryColor,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: kDarkPrimaryColor,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.white,
          backgroundColor: kDarkPrimaryColor,
          unselectedItemColor: kDarkSecondaryColor),
      textTheme: darkTextTheme,
      primaryColor: kDarkPrimaryColor,
    );
  }
}
