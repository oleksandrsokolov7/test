import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:my_period_tracker/firebase/services/firebase_service.dart';
import 'package:my_period_tracker/firebase/services/firestore_service.dart';
import 'dashboard_screen.dart';

class RegistrationScreen extends StatefulWidget {
  final String periodLength;
  final String cycleLength;
  final DateTime dateOfBirth;
  final DateTime lastPeriodStartDate;

  const RegistrationScreen({
    super.key,
    required this.periodLength,
    required this.cycleLength,
    required this.dateOfBirth,
    required this.lastPeriodStartDate,
  });

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late DateTime _lastPeriodDate;
  int _currentStep = 0;
  bool _isPasswordVisible = false;
  String? _emailError;
  String? _nameError;

  final FirebaseService _firebaseService = FirebaseService();
  final FirestoreService _firestoreService = FirestoreService();

  // Regular expression for email validation
  final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );

  // Regular expression for password validation (at least 8 characters and 1 symbol)
  final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$',
  );

  @override
  void initState() {
    super.initState();
    _lastPeriodDate = widget.lastPeriodStartDate;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!_emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long and contain at least one symbol';
    }
    if (!_passwordRegExp.hasMatch(value)) {
      return 'Please enter a valid password';
    }
    return null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildCurrentStep(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_currentStep < 2) {
                    if (_validateCurrentStep()) {
                      setState(() {
                        _currentStep++;
                      });
                    }
                  } else {
                    if (_formKey.currentState!.validate()) {
                      // Register the user with Firebase
                      User? user =
                          await _firebaseService.createUserWithEmailPassword(
                        _emailController.text,
                        _passwordController.text,
                      );
                      if (user != null) {
                        // Save user data to Firestore
                        try {
                          int periodLength =
                              int.parse(extractDigits(widget.periodLength));
                          int cycleLength =
                              int.parse(extractDigits(widget.cycleLength));

                          await _firestoreService.registerUser(
                            userId: user.uid,
                            name: _nameController.text,
                            email: _emailController.text,
                            dateOfBirth: widget.dateOfBirth,
                            periodLength: periodLength,
                            cycleLength: cycleLength,
                            lastPeriodDate: _lastPeriodDate,
                          );

                          // Navigate to Dashboard
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DashboardScreen(
                                name: _nameController.text,
                                email: _emailController.text,
                                periodLength: widget.periodLength,
                                cycleLength: widget.cycleLength,
                                dateOfBirth: widget.dateOfBirth,
                                lastPeriodDate: _lastPeriodDate,
                              ),
                            ),
                            (route) => false,
                          );
                        } catch (e) {
                          // Обработка ошибки преобразования
                          print(
                              'Error parsing periodLength or cycleLength: $e');
                          // Вы можете показать сообщение об ошибке пользователю
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Invalid period length or cycle length')),
                          );
                        }
                      }
                    }
                  }
                },
                child: Text(_currentStep < 2 ? 'Next' : 'Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        if (_nameController.text.isEmpty) {
          setState(() {
            _nameError = 'Please enter your name';
          });
          return false;
        }
        return true;
      case 1:
        final emailError = _validateEmail(_emailController.text);
        setState(() {
          _emailError = emailError;
        });
        return emailError == null;
      default:
        return true;
    }
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildNameStep();
      case 1:
        return _buildEmailStep();
      case 2:
        return _buildPasswordStep();
      default:
        return Container();
    }
  }

  Widget _buildNameStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter your name',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        const SizedBox(height: 40),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'Name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            errorText: _nameError,
          ),
          textInputAction: TextInputAction.next,
        ),
      ],
    );
  }

  Widget _buildEmailStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter your email',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'To make sure you do not lose your data and can use the app on any device, please create an account',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 40),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: 'E-mail',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            errorText: _emailError,
          ),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        Text(
          'Keeping your account and information safe is our top priority and we promise never to spam you with unsolicited emails!',
          style: TextStyle(
            fontSize: 12,
            color: Colors.blue[700],
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordStep() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter your password',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'The length should be at least 8 symbols and contain at least one symbol',
            style: TextStyle(
              fontSize: 14,
              color: Colors.pink,
            ),
          ),
          const SizedBox(height: 40),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              hintText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
            obscureText: !_isPasswordVisible,
            // validator: _validatePassword,
          ),
        ],
      ),
    );
  }
}

String extractDigits(String input) {
  final RegExp digitRegExp = RegExp(r'\d+');
  final match = digitRegExp.firstMatch(input);
  if (match != null) {
    return match.group(0)!;
  }
  throw const FormatException('No digits found in input');
}
