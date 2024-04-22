import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPasswordView extends StatelessWidget {
  ResetPasswordView({super.key});

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("AssignMate Reset Password"),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                  "Please Enter your Email to recieve a password reseting email.",
                  textScaleFactor: 1.5,
                  textAlign: TextAlign.center,
              ),

              const SizedBox(height: 15,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade900),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    hintText: "Email",
                  ),
                ),
              ),

              const SizedBox(height: 15,),

              MaterialButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                        email: emailController.text.trim()
                    );
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Password Reset Email Sent"),
                        content: Text("A password resetting email has been sent to ${emailController.text.trim()}."),
                        actions: [
                          TextButton(
                            onPressed: () => {Navigator.pop(context),Navigator.pop(context)},
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                    );
                  } on FirebaseAuthException catch (e) {
                    showDialog(context: context, builder: (context){
                      return AlertDialog(
                        title: Text(e.message.toString()),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("OK"),
                          ),
                        ],
                      );
                    });
                  }
                },
                color: Colors.red,
                child: const Text("Reset Password"),
              )
            ]
          ),
        ),
      ),
    );
  }
}
