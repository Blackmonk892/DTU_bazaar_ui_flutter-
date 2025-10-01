import 'package:flutter/material.dart';
import 'package:dtu_bazaar/pages/homepage.dart';
import 'package:dtu_bazaar/auth/auth_page.dart';
import 'package:dtu_bazaar/pages/sell_page.dart';
import 'package:dtu_bazaar/pages/my_account_page.dart';
import 'package:dtu_bazaar/pages/buy_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DTU Bazaar',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        '/auth': (context) => const AuthPage(),
        '/sell': (context) => SellPageWeb(),
        '/buy': (context) => BuyPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/account') {
          return MaterialPageRoute(
            builder: (context) => const MyAccountPage(), // ✅ Fixed here
          );
        }
        return null;
      },
    );
  }
}
