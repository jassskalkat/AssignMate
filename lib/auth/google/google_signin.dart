import 'package:assign_mate/routes/route_generator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../database/database.dart';

class GoogleSignInButton {
  late NavigatorState navigator;

  Widget buildGoogleSignInButton(BuildContext context){
    TextEditingController usernameController = TextEditingController();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SignInButton(
          Buttons.GoogleDark,
          onPressed: () async {
            loading(context);

            GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

            List<String> signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(gUser!.email);

            finishedLoading();

            if (signInMethods.isEmpty) {
              await showDialog(context: context,barrierDismissible: false, builder: (context) =>
                  AlertDialog(
                    title: const Text('Enter a username'),
                    content: TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(hintText: "Username"),
                    ),
                    actions: [
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          if(usernameController.text != ''){
                            loading(context);
                            final snapshot = await Database().getUserData(usernameController.text);
                            finishedLoading();

                            if (snapshot.docs.isNotEmpty) {
                              showDialog(context: context, builder: (context) {
                                return const AlertDialog(
                                  title: Text(
                                      'Username already exists. Please choose a different username.'),
                                );
                              });
                            }
                            else{
                              loading(context);
                              GoogleSignInAuthentication gAuth = await gUser.authentication;
                              final credential = GoogleAuthProvider.credential(
                                accessToken: gAuth.accessToken,
                                idToken: gAuth.idToken,
                              );
                              final userCred = await FirebaseAuth.instance.signInWithCredential(credential);
                              await Database(userid: userCred.user!.uid).addUser(usernameController.text, userCred.user!.email!);
                              finishedLoading();

                              Navigator.pop(context);
                              Navigator.pushNamed(context, RouteGenerator.homePage);
                            }
                          }
                        },
                      ),
                    ],
                  ),
              );
            }
            else{
              loading(context);
              final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
              final GoogleSignInAuthentication gAuth = await gUser!.authentication;
              final credential = GoogleAuthProvider.credential(
                accessToken: gAuth.accessToken,
                idToken: gAuth.idToken,
              );

              await FirebaseAuth.instance.signInWithCredential(credential);
              finishedLoading();
              Navigator.pushNamed(context, RouteGenerator.homePage);
            }
          },
        )
      ],
    );
  }

  void loading(BuildContext context){
    showDialog(context: context,barrierDismissible: false, builder: (context){
      return const AlertDialog(
        content: CircularProgressIndicator(),
      );
    });
    navigator = Navigator.of(context);
  }

  void finishedLoading(){
    navigator.pop();
  }
}