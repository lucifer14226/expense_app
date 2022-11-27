//import 'dart:html';

import 'package:expense_app/auth/auth_services.dart';
import 'package:expense_app/firebase_options.dart';
import 'package:expense_app/routes.dart';
//import 'package:expense_app/view/home_view.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../excpetion.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login View"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            obscureText: false,
            decoration: const InputDecoration(hintText: "Enter your Email id"),
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _password,
            obscureText: true,
            autocorrect: false,
            decoration: const InputDecoration(hintText: "Enter your Password"),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              await Firebase.initializeApp(
                options: DefaultFirebaseOptions.currentPlatform,
              );
              try {
                await AuthServices.firebase().logIn(
                  email: email,
                  password: password,
                );
                final user = AuthServices.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    homePageRoutes,
                    (route) => false,
                  );
                } else {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyemail,
                    (route) => false,
                  );
                }
              } on WrongPasswordException {
                ("Wrong Password");
              } on UserNotFoundException {
                print("user not found");
              }
            },
            child: const Text("login"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoutes, (route) => false);
            },
            child: const Text("Don't have an account? Register here!!"),
          )
        ],
      ),
    );
  }
}
