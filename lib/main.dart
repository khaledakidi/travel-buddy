import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'theme.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const TravelBuddyApp(),
    ),
  );
}

class TravelBuddyApp extends StatelessWidget {
  const TravelBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = context.watch<AppState>().darkMode;
    return MaterialApp(
      title: 'Travel Buddy',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(false),
      darkTheme: buildTheme(true),
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}
