import 'package:campus_connect/screens/Landing.dart';
import 'package:campus_connect/screens/Welcome/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

          if (FirebaseAuth.instance.currentUser!=null){
            /// user already logged in
            return MaterialApp(
              home: LandingScreen(),
            );
          }
          /// no user logged in
          return MaterialApp(
            home: WelcomeScreen(),
          );
        }
  }


