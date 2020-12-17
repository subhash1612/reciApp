import 'package:flutter/material.dart';
import 'package:recipe/screens/register.dart';
import 'package:recipe/screens/sign_in.dart';

class authenticate extends StatefulWidget {
  @override
  _authenticateState createState() => _authenticateState();
}

class _authenticateState extends State<authenticate> {

  bool showSignIn = true;
  void toggle()
  {
    setState(() => showSignIn = !showSignIn);
  }
  @override
  Widget build(BuildContext context) {
    if(showSignIn)
      {
        return signIn(toggle:toggle);
      }
    else
      {
        return register(toggle:toggle);
      }
  }
}
