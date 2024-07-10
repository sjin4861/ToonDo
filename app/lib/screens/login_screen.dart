import 'package:blossomdays/widgets/social_login_button.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _attemptLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      // 로그인 성공
      Navigator.pop(context, true);
    }
  }
  void _googleSignIn() {
    // Google 로그인 로직 추가
  }

  void _facebookSignIn() {
    // Facebook 로그인 로직 추가
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 200,
                child: RiveAnimation.asset(
                  'assets/animations/flower_animation.riv',
                ),
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      key: Key('email_field'), // 추가된 key
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      key: Key('password_field'), // 추가된 key
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 32),
                    ElevatedButton(
                      key: Key('login_button'), // 추가된 key
                      onPressed: _attemptLogin,
                      child: Text('Login'),
                    ),
                    SocialLoginButton(
                      text: 'Sign in with Google',
                      color: Colors.red,
                      icon: Icons.login,
                      onPressed: _googleSignIn,
                    ),
                    SizedBox(height: 10),
                    SocialLoginButton(
                      text: 'Sign in with Facebook',
                      color: Colors.blue,
                      icon: Icons.login,
                      onPressed: _facebookSignIn,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}