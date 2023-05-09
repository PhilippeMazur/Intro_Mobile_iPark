import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ipark/chooseScreen.dart';
import 'package:ipark/login.dart';
import 'package:ipark/provider/authentication_provider.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'navigation.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
  debugPrint(FirebaseFirestore.instance.collection('account').toString());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthenticationProvider(),
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Navigation()
          //     Consumer<AuthenticationProvider>(builder: (context, login, child) {
          //   if (login.loggedIn) {
          //     return choosePage();
          //   } else {
          //     return loginScreen();
          //   }
          // }),
          ),
    );
  }
}
