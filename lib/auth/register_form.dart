import 'package:flutter/material.dart';
import 'package:dtu_bazaar/services/auth_service.dart';
import 'package:dtu_bazaar/utils/token_storage.dart';
import 'package:dtu_bazaar/pages/my_account_page.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscure1 = true;
  bool obscure2 = true;
  bool isLoading = false;
  String error = '';

  Future<void> _handleRegister() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (password != confirmPassword) {
      setState(() => error = "Passwords do not match");
      return;
    }

    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      final result = await AuthService.register(email, password);
      final token = result['access_token'];

      if (token != null) {
        // ✅ Save token
        await TokenStorage.saveToken(token);

        // ✅ Guard against async context issues
        if (!mounted) return;

        // ✅ Navigate without passing token
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MyAccountPage()),
        );
      } else {
        setState(() => error = 'Registration failed. No token received.');
      }
    } catch (e) {
      setState(() => error = 'Registration failed: ${e.toString()}');
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
          obscureText: obscure1,
          decoration: InputDecoration(
            hintText: "P a s s w o r d",
            suffixIcon: IconButton(
              icon: Icon(obscure1 ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => obscure1 = !obscure1),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: confirmPasswordController,
          obscureText: obscure2,
          decoration: InputDecoration(
            hintText: "C o n f i r m  P a s s w o r d",
            suffixIcon: IconButton(
              icon: Icon(obscure2 ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => obscure2 = !obscure2),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: isLoading ? null : _handleRegister,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
          ),
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Register"),
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
