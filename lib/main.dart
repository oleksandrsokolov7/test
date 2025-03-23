import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_period_tracker/screen/welcome_screen.dart';
import 'package:my_period_tracker/screen/registration_screen.dart';
import 'package:my_period_tracker/screen/login_screen.dart';
import 'package:my_period_tracker/screen/dashboard_screen.dart';
import 'package:my_period_tracker/screen/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const PeriodTrackerApp());
}

class PeriodTrackerApp extends StatelessWidget {
  const PeriodTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Period Tracker',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const AuthGate(),
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/register': (context) => RegistrationScreen(
              periodLength: '',
              cycleLength: '',
              dateOfBirth: DateTime.now(),
              lastPeriodStartDate:
                  DateTime.now().subtract(const Duration(days: 15)),
            ),
        '/login': (context) => const LoginScreen(),
        '/settings': (context) => SettingsScreen(
              name: '',
              email: '',
              periodLength: '',
              cycleLength: '',
              dateOfBirth: DateTime.now(),
              lastPeriodDate: DateTime.now().subtract(const Duration(days: 15)),
            ),
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return const WelcomeScreen();
          } else {
            return DashboardScreen(
              name: user.displayName,
              email: user.email,
              periodLength: '',
              cycleLength: '',
              dateOfBirth: DateTime.now(),
              lastPeriodDate: DateTime.now().subtract(const Duration(days: 15)),
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
