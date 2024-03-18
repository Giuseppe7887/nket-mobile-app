// UI
import 'package:flutter/material.dart';

// firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:nket/services/firebase/auth.dart';
import 'firebase_options.dart';



// SCREENS
import "package:nket/screens/Home.dart";
import "package:nket/screens/Login.dart";
import 'package:nket/screens/Index.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value)async{
    runApp(const Nket());
  });
}

class Nket extends StatelessWidget {
  const Nket({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
          stream: Auth().authState(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return MaterialApp(
              title: "Notiko",
              theme: ThemeData(
                  primarySwatch: Colors.blue
              ),
              home: snapshot.hasData ? Index():const Login()
            );
          },
        );
  }
}



