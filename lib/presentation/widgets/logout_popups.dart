import 'package:flutter/material.dart';
import 'package:it_department/presentation/screens/login/login_screen.dart';

class LogoutPopup extends StatefulWidget {
  const LogoutPopup({super.key});

  @override
  State<LogoutPopup> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<LogoutPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('IT DEPARTMENT'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog first
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }
}
