// ignore_for_file: use_build_context_synchronously, unused_field

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_connect/screens/home_screen.dart';

import 'package:study_connect/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signup() async {
    try {
      final String email = _emailcontroller.text.trim();

      final String password = _passwordcontroller.text.trim();

      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please fill in both fields ")));
        return;
      }

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("User not fond on that email")));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Wrong password provided")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("An error occure")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text(
                "Study Connect",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const Text("Login your account for Study Connect"),
              const Icon(
                Icons.group,
                size: 100,
                color: Color.fromARGB(2555, 241, 156, 10),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _emailcontroller,
                decoration: const InputDecoration(
                  suffixIcon: Icon(
                    Icons.mail,
                    color: Color.fromARGB(2555, 241, 156, 10),
                  ),
                  hintText: "Email",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 241, 156, 10), width: 2.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _passwordcontroller,
                obscureText: true,
                decoration: const InputDecoration(
                  suffixIcon: Icon(
                    Icons.lock,
                    color: Color.fromARGB(2555, 241, 156, 10),
                  ),
                  hintText: "Password",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 241, 156, 10), width: 2.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              InkWell(
                onTap: signup,
                child: Container(
                  height: 30,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 241, 156, 10)),
                  alignment: Alignment.center,
                  child: const Text("Sign Up "),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("You don't have an account"),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ));
                      },
                      child: const Text("Register"))
                ],
              )
            ]),
          )),
    );
  }
}
