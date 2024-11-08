import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:study_connect/firebase_options.dart';
import 'package:study_connect/screens/home_screen.dart';
import 'package:study_connect/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // This line is needed
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => GroupProvider(),
      )
    ],
    child: const StudyConnect(),
  ));
}

class StudyConnect extends StatefulWidget {
  const StudyConnect({super.key});

  @override
  State<StudyConnect> createState() => _StudyConnectState();
}

class _StudyConnectState extends State<StudyConnect> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
