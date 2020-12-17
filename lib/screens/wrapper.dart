import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe/screens/home.dart';
import 'package:recipe/screens/auth.dart';
import 'package:recipe/models/user.dart';

class wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    if(user == null) //if user is logged out
      {
        return authenticate();
      }
    else
      {
        return home();
      }
  }
}
