import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_period_tracker/screen/settings_screen.dart';

void showAccountOptions(
    BuildContext context,
    String? name,
    String? email,
    String periodLength,
    String cycleLength,
    DateTime dateOfBirth,
    DateTime lastPeriodDate) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.pink[100],
                child: const Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                name ?? 'User',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                email ?? 'No email provided',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsScreen(
                        name: name,
                        email: email,
                        periodLength: periodLength,
                        cycleLength: cycleLength,
                        dateOfBirth: dateOfBirth,
                        lastPeriodDate: lastPeriodDate,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title:
                    const Text('Log Out', style: TextStyle(color: Colors.red)),
                onTap: () async {
                  Navigator.pop(context);
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/welcome',
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
