import 'package:flutter/material.dart';
import 'package:dtu_bazaar/services/auth_service.dart';
import 'package:dtu_bazaar/utils/token_storage.dart';
import 'package:dtu_bazaar/pages/my_account_page.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscure = true;
  bool isLoading = false;
  String error = '';

  Future<void> _handleLogin() async {
    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      final result = await AuthService.login(
        emailController.text.trim(),
        passwordController.text,
      );

      final token = result['access_token'];
      if (token != null) {
        // ✅ Save token locally
        await TokenStorage.saveToken(token);

        // ✅ Navigate to MyAccountPage (no need to pass token)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MyAccountPage()),
        );
      } else {
        setState(() {
          error = 'Invalid credentials or no token received';
        });
      }
    } catch (e) {
      setState(() {
        error = 'Login failed: ${e.toString()}';
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: emailController,
          decoration: const InputDecoration(hintText: "D T U  E m a i l"),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: passwordController,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: "P A S S W O R D",
            suffixIcon: IconButton(
              icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => obscure = !obscure),
            ),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: isLoading ? null : _handleLogin,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
          ),
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Login"),
        ),
        if (error.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(error, style: const TextStyle(color: Colors.red)),
          ),
      ],
    );
  }
}
