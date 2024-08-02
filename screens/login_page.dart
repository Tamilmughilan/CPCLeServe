import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _prNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _captchaController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _prNoAnimation;
  late Animation<double> _passwordAnimation;
  late Animation<double> _captchaAnimation;
  late Animation<double> _buttonAnimation;
  String _captcha = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _prNoAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _passwordAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _captchaAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _buttonAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();

    _generateCaptcha();
  }

  void _generateCaptcha() {
    const letters =
        'abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ1234567890';
    const length = 6;
    final random = Random();
    _captcha = String.fromCharCodes(
      List.generate(length,
          (index) => letters.codeUnitAt(random.nextInt(letters.length))),
    );
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    _prNoController.dispose();
    _passwordController.dispose();
    _captchaController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final prNo = _prNoController.text;
    final password = _passwordController.text;
    final captcha = _captchaController.text;

    if (prNo.isEmpty || password.isEmpty || captcha.isEmpty) {
      _showError('Please enter PR Number, Password, and Captcha.');
      return;
    }

    if (captcha != _captcha) {
      _showError('Captcha is incorrect. Please try again.');
      _generateCaptcha();
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:5062/api/Login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'prNo': int.parse(prNo),
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, '/home', arguments: prNo);
      } else {
        final responseBody = jsonDecode(response.body);
        final message =
            responseBody['message'] ?? 'Login failed. Please try again.';
        _showError(message);
        _generateCaptcha();
      }
    } catch (e) {
      _showError('An unexpected error occurred. Please try again.');
      _generateCaptcha();
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 126, 197, 255),
              Colors.blue.shade900
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FadeTransition(
                    opacity: _controller,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20), // Move logo up
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 200, // Make it larger
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  FadeTransition(
                    opacity: _prNoAnimation,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                        style: const TextStyle(color: Colors.black),
                        controller: _prNoController,
                        decoration: InputDecoration(
                          labelText: 'PR Number',
                          labelStyle: const TextStyle(
                              color: Color.fromARGB(179, 0, 0, 0)),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 137, 198, 247),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 0, 0, 0),
                                width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 214, 36, 20),
                                width: 2.8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 20.0), // Increase vertical padding
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeTransition(
                    opacity: _passwordAnimation,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                        style: const TextStyle(color: Colors.black),
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(
                              color: Color.fromARGB(179, 0, 0, 0)),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 137, 198, 247),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 0, 0, 0),
                                width: 2.8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 214, 36, 20),
                                width: 2.8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 20.0), // Increase vertical padding
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                        obscureText: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeTransition(
                    opacity: _captchaAnimation,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Captcha: $_captcha',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: _generateCaptcha,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          style: const TextStyle(color: Colors.black),
                          controller: _captchaController,
                          decoration: InputDecoration(
                            labelText: 'Enter Captcha',
                            labelStyle: const TextStyle(
                                color: Color.fromARGB(179, 0, 0, 0)),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 137, 198, 247),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 214, 36, 20),
                                  width: 2.8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 20.0), // Increase vertical padding
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  ScaleTransition(
                    scale: _buttonAnimation,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 209, 235, 249),
                        foregroundColor: const Color.fromARGB(255, 4, 73, 177),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 32.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child:
                          const Text('Login', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
              Flexible(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    '@Chennai Petroleum Corporation Ltd',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
