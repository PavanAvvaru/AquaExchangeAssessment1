import 'package:flutter/material.dart';
import 'package:assesmentproject/pages/loginpage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyAWVuXQA-uXT32yRGtUik90qYrolyHmBzY",
          appId: "1:1007124148954:web:cbad621378af64d3e32be3",
          messagingSenderId: "1007124148954",
          projectId: "basicapp-371a6"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: LoginPage()
        /*
        if you not change database use below login credentials for login
        emial : nani@gmail.com
        password: nani@123
        */
        );
  }
}
