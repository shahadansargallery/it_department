// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:it_department/logic/auth/login_service.dart';
import 'package:it_department/presentation/screens/home/home_screen.dart';
import 'package:toastification/toastification.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userIdTextController = TextEditingController();
  final _userPasswordTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _userIdTextController.dispose();
    _userPasswordTextController.dispose();
    super.dispose();
  }

  void _showSuccess(bool isSuccess) {
    toastification.show(
      context: context,
      title: Text(isSuccess ? "Login Success" : "Login Failed"),
      description: Text(
        isSuccess
            ? "You are Logged In Successfully"
            : "Invalid username or password",
      ),
      type: isSuccess ? ToastificationType.success : ToastificationType.error,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.topCenter,
    );
  }

  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 50),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Text(
                      "IT DEPARTMENT",
                      style: TextStyle(
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _userIdTextController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Username can't be empty";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter your UserId",
                      labelText: 'User Id',
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _userPasswordTextController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password can't be empty";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter your Password",
                      labelText: 'Password',
                    ),
                  ),
                  const SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          final isSuccess = await authService.login(
                            _userIdTextController.text,
                            _userPasswordTextController.text,
                          );

                          print(isSuccess);

                          if (isSuccess) {
                            _showSuccess(true); // ✅ success toast

                            _userIdTextController.clear();
                            _userPasswordTextController.clear();

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          } else {
                            _showSuccess(false);
                          }
                        } catch (e) {
                          print("error ${e}");
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      "Log In",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
