import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe/models/user.dart';
import 'package:async/async.dart';
import 'package:flutter/services.dart';
import 'dart:async';



class AuthService
{
    final FirebaseAuth _auth = FirebaseAuth.instance;

    // create user object based on firebase user
    User _userfromFirebase(FirebaseUser user)
    {
        return user!=null?User(uid: user.uid): null;
    }
    //auth change user stream
    Stream<User> get user
    {
       return _auth.onAuthStateChanged.map(_userfromFirebase);

    }
    // sign in with email and password
    Future signIn(String email, String password) async {
      try {
        AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
        FirebaseUser user = result.user;
        return _userfromFirebase(user);
      }catch(e)
      {
        print(e.toString());
        return null;
      }
    }
    // register with email and password
    Future register(String email, String password) async {
      try {
        AuthResult result = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        FirebaseUser user = result.user;
        return _userfromFirebase(user);
      }catch(e)
      {
         print(e.toString());
         return null;
      }
    }
    // sign out

   Future signOut() async {
       try {
           return _auth.signOut();
       } catch (e) {
           print(e.toString());
           return null;
       }
   }


}