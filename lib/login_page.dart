import 'dart:convert';
import 'package:damkar/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String _errorMessage = '';

  Future<List<Map<String, dynamic>>> _loadUsers() async {
    String data = await rootBundle.loadString('assets/users.json');
    return List<Map<String, dynamic>>.from(json.decode(data));
  }

  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    List<Map<String, dynamic>> users = await _loadUsers();

    var user = users.firstWhere(
      (u) => u['username'] == username && u['password'] == password,
      orElse: () => {},
    );

    if (user.isNotEmpty) {
      setState(() => _errorMessage = '');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selamat datang, ${user['role']}')),
      );

      // Redirect ke HomePage setelah sedikit delay agar snackbar tampil
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      });
    } else {
      setState(() => _errorMessage = 'Username atau password salah');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset('assets/logo_damkar.png', height: 120),
                const SizedBox(height: 16),
                const Text(
                  'LOGIN DAMKAR',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                if (_errorMessage.isNotEmpty)
                  Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                  ),
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
