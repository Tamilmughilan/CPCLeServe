import 'package:flutter/material.dart';
import 'package:cpcl/screens/login_page.dart';
import 'package:cpcl/screens/home_page.dart';
import 'package:cpcl/screens/profile_page.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(228, 211, 17, 17),
);

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 5, 12, 56),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        cardTheme: const CardTheme().copyWith(
          color: kDarkColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.primaryContainer,
            foregroundColor: kDarkColorScheme.onPrimaryContainer,
          ),
        ),
      ),
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: const Color.fromARGB(224, 232, 12, 12),
          foregroundColor: const Color.fromARGB(255, 8, 16, 59),
        ),
        cardTheme: const CardTheme().copyWith(
          color: const Color.fromARGB(227, 80, 101, 216),
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.primaryContainer,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                fontWeight: FontWeight.bold,
                color: kColorScheme.onSecondaryContainer,
                fontSize: 20,
              ),
            ),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const LoginPage());
          case '/home':
            final prNo = settings.arguments as String;
            return MaterialPageRoute(builder: (_) => HomePage(prNo: prNo));
          case '/profile':
            final prNo = settings.arguments as String;
            return MaterialPageRoute(builder: (_) => ProfilePage(prNo: prNo));
          default:
            return null;
        }
      },
    );
  }
}
