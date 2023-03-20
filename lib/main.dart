import 'package:flutter/material.dart';

import 'package:products_app/screens/screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: const AppBarTheme(elevation: 0, color: Colors.indigo),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.indigo, elevation: 0),
      ),
      initialRoute: "home_screen",
      routes: {
        "home_screen": (context) => const HomeScreen(),
        "login_screen": (context) => const LoginScreen(),
        "product_screen": (context) => const ProductScreen(),
      },
    );
  }
}
