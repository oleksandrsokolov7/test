import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_period_tracker/firebase/services/firebase_service.dart';
import 'package:my_period_tracker/firebase/services/firestore_service.dart';
import 'package:my_period_tracker/screen/dashboard_screen.dart';
import 'package:my_period_tracker/screen/login_screen.dart';
// Импортируем FirestoreService

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseService().authStateChanges, // Используем FirebaseService
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Получаем данные пользователя
          String userId = snapshot.data!.uid;

          // Используем FirestoreService для получения данных пользователя
          FirestoreService().getUserData(userId).then((userData) {
            if (userData != null) {
              // Отображаем экран с данными пользователя
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DashboardScreen(
                    periodLength: userData['periodLength'].toString(),
                    cycleLength: userData['cycleLength'].toString(),
                    dateOfBirth: DateTime.parse(userData['dateOfBirth']),
                    lastPeriodDate: DateTime.parse(userData['lastPeriodDate']),
                  ),
                ),
              );
            }
          });

          return const CircularProgressIndicator(); // Пока данные загружаются
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
