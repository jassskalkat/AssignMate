
import 'package:assign_mate/routes/route_generator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UnknownScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Center(
        child: Text('Oops something went wrong!'),
      ),
          ElevatedButton(onPressed: ()=>{FirebaseAuth.instance.signOut(), Navigator.pushNamed(context, RouteGenerator.authPage)}, child: Text("sign out"))
        ]
      ),
    );
  }
}