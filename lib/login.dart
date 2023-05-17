///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ipark/model/account.dart';
import 'package:ipark/provider/authentication_provider.dart';
import 'package:ipark/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class loginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Failed'),
          content: const Text('email or password is incorrect'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _checkCredentials(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      if (!emailController.text.contains("@") ||
          !emailController.text.contains(".") ||
          passwordController.text == "") {
        _dialogBuilder(context);
      } else {
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        try {
          FirebaseFirestore.instance
              .collection('accounts')
              .where('user_uid',
                  isEqualTo: FirebaseAuth.instance.currentUser?.uid)
              .get()
              .then((QuerySnapshot snapshot) {
            if (snapshot.docs.isNotEmpty) {
              Account account = Account.fromMap(
                  snapshot.docs.first.data() as Map<String, dynamic>);
              account.id = snapshot.docs.first.id;
              Provider.of<AuthenticationProvider>(context, listen: false)
                  .login(account);
              logger.d(account);
            } else {
              logger.e("bestaat niet");
            }
          });
        } catch (e) {
          logger.e(e);
        }
        logger.d('succeeded');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        logger.e('not succeeded');
      } else if (e.code == 'wrong-password') {
        print('not succeeded');
        _dialogBuilder(context);
      }
    } on Exception catch (e) {
      _dialogBuilder(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image(
                    image: AssetImage("assets/images/logoipark.png"),
                    height: 250,
                    width: 250,
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 16),
                  child: Text(
                    "LOGIN TO CONTINUE",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 17,
                      color: Color(0xff0815b8),
                    ),
                  ),
                ),
                TextField(
                  controller: emailController,
                  obscureText: false,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                  decoration: InputDecoration(
                    disabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide:
                          BorderSide(color: Color(0xff000000), width: 1),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide:
                          BorderSide(color: Color(0xff000000), width: 1),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide:
                          BorderSide(color: Color(0xff000000), width: 1),
                    ),
                    labelText: "Email",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 16,
                      color: Color(0xff7c7878),
                    ),
                    hintText: "Enter Text",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Color(0xff000000),
                    ),
                    filled: true,
                    fillColor: Color(0x00ffffff),
                    isDense: false,
                    contentPadding: EdgeInsets.all(0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Color(0xff000000),
                    ),
                    decoration: InputDecoration(
                      disabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide:
                            BorderSide(color: Color(0xff000000), width: 1),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide:
                            BorderSide(color: Color(0xff000000), width: 1),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide:
                            BorderSide(color: Color(0xff000000), width: 1),
                      ),
                      labelText: "Password",
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 16,
                        color: Color(0xff7c7878),
                      ),
                      hintText: "Enter Text",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xff000000),
                      ),
                      filled: true,
                      fillColor: Color(0x00ffffff),
                      isDense: false,
                      contentPadding: EdgeInsets.all(0),
                      suffixIcon: Icon(Icons.visibility,
                          color: Color(0xff7b7c82), size: 24),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 50),
                  child: MaterialButton(
                    onPressed: () {
                      _checkCredentials(context);
                    },
                    color: Color(0xff091abd),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    textColor: Color(0xffffffff),
                    height: 50,
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => register()),
                    );
                  },
                  color: Color(0x2d3a57e8),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Create account",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  textColor: Color(0xff3a57e8),
                  height: 50,
                  minWidth: MediaQuery.of(context).size.width,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
