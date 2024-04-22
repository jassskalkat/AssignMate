import 'package:assign_mate/routes/route_generator.dart';
import 'package:flutter/material.dart';

class AssignMateApp extends MaterialApp {
  AssignMateApp({Key? key}) : super(key: key,
      initialRoute:  RouteGenerator.authPage,
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: ThemeData(
          primarySwatch: Colors.red,
          ),
  );
}