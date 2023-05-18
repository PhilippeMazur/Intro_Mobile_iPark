import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:ipark/login.dart';
import 'package:ipark/provider/authentication_provider.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'navigation.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

Future<dynamic> fetchJson(String url) async {
  final file = await DefaultCacheManager().getSingleFile(url);

  // If the file exists in the cache, read and return it as JSON
  if (await file.exists()) {
    final jsonString = await file.readAsString();
    //logger.d("request from cache");
    return json.decode(jsonString);
  }

  // If the file doesn't exist in the cache, fetch it and save it to the cache
  var http;
  final response = await http.get(Uri.parse(url));
  final jsonData = response.bodyBytes;

  await DefaultCacheManager().putFile(
    url,
    Uint8List.fromList(jsonData),
  );

  return json.decode(utf8.decode(jsonData));
}

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
        home: AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(statusBarColor: Colors.black),
            child: SafeArea(
              child: Consumer<AuthenticationProvider>(
                  builder: (context, login, child) {
                if (login.user != null) {
                  return const Navigation();
                } else {
                  return loginScreen();
                }
              }),
            )),
      ),
    );
  }
}
