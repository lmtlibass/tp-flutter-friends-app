import 'package:flutter/material.dart';
import 'package:myfriends/screens/accueil_screen.dart';
import 'package:myfriends/screens/best_friend_screen.dart';
import 'package:myfriends/screens/compteur_screen.dart';
import 'package:myfriends/screens/container_screen.dart';
import 'package:myfriends/screens/details_ami_screen.dart';
import 'package:myfriends/screens/like_screen.dart';
import 'package:myfriends/screens/liste_amis_screen.dart';
import 'package:myfriends/screens/pass.dart';

void main() {
  runApp(const MyApp());
}

class AppColors {
  static const teal   = Color(0xFF0094A7);
   static const pink  = Color(0xFFDC2C8C);
  static const gold   = Color(0xFFFBBF24);
  static const bg     = Color(0xFFFAFAFA);
  static const dark   = Color(0xFF1F2937);
  static const gray   = Color(0xFF6B7280);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Friends',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.teal),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.pink,
          foregroundColor: Colors.white,
        )
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomePage(),
        '/list_amis': (context) => ListeAmisScreen(),
        'detail_ami': (context) => DetailsAmiScreen(),
        '/best': (context) => BestFriendScreen(),
        '/compteur': (context) => CompteurScreen(),
        '/like': (context) => LikeScreen(),
        '/pass': (context) => PassScreen(),
        '/container': (context) => ContainerScreen()
      },
      home: HomePage(),
    );
  }
}
