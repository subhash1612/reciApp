import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe/screens/wrapper.dart';
import 'package:recipe/screens/wrapper.dart';
import 'package:recipe/services/auth_service.dart';
import 'package:recipe/models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: wrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
