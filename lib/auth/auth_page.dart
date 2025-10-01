import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_form.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 420),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.all(24),
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => setState(() => isLogin = true),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontWeight: isLogin
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isLogin ? Colors.indigo : Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      TextButton(
                        onPressed: () => setState(() => isLogin = false),
                        child: Text(
                          "Register",
                          style: TextStyle(
                            fontWeight: !isLogin
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: !isLogin ? Colors.indigo : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 350),
                    transitionBuilder: (child, animation) => SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(1.0, 0),
                        end: Offset(0.0, 0.0),
                      ).animate(animation),
                      child: child,
                    ),
                    child: isLogin
                        ? LoginForm(key: ValueKey(1))
                        : RegisterForm(key: ValueKey(2)),
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
