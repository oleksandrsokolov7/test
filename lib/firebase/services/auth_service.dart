import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<User?> registerUser({
    required String email,
    required String password,
    required String name,
    required DateTime dateOfBirth,
    required int periodLength,
    required int cycleLength,
    required DateTime lastPeriodDate,
  }) async {
    try {
      // Регистрируем пользователя
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Сохраняем данные в Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'dateOfBirth': dateOfBirth.toIso8601String(),
          'periodLength': periodLength,
          'cycleLength': cycleLength,
          'lastPeriodDate': lastPeriodDate.toIso8601String(),
          'createdAt': FieldValue.serverTimestamp(),
        });

        return user;
      }
      return null;
    } catch (e) {
      throw FirebaseAuthException(message: 'Ошибка регистрации: $e', code: '');
    }
  }
}
