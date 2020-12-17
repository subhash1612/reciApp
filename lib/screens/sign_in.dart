import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe/services/auth_service.dart';
import 'package:recipe/shared_code/loading.dart';

class signIn extends StatefulWidget {

  final Function toggle;
  signIn({this.toggle});

  @override
  _signInState createState() => _signInState();
}

class _signInState extends State<signIn> {

  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String error = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading ? Loading():Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xff21254A),
        body:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 200,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                      image:AssetImage('assets/images/logindesign.png'),
                          fit: BoxFit.cover
                      ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height:20.0
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal:20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Hello There, \nWelcome Back",
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.transparent
                    ),
                    child:Form(
                        key : _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding:EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey[100]
                                  )
                                )
                              ),
                              child: TextFormField(
                                validator: (val) => val.isEmpty ? "Enter an Email" : null,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter Email",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[100],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                onChanged: (val){
                                  setState(() {
                                    email = val;
                                  });

                                },
                              ),
                            ),

                            Container(
                              padding:EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey[100]
                                      )
                                  )
                              ),
                              child: TextFormField(
                                validator: (val) => val.length<6 ? "Enter a password 6+ characters long" : null,
                                style: TextStyle(color: Colors.white),
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter Password",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[100],
                                    fontStyle: FontStyle.italic,
                                  ),),
                                onChanged: (val)
                                {
                                  setState(() {
                                    password = val;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height:20.0),
                            Container(
                              height: 50,
                              margin: EdgeInsets.symmetric(horizontal: 60.0),
                              child: RaisedButton(
                                color: Color.fromRGBO(49, 39, 29, 1),
                                child: Center(
                                  child: Text("Sign In",
                                    style: TextStyle(color: Colors.white),),
                                ),
                                onPressed: () async{
                                  if(_formKey.currentState.validate())
                                  {
                                    setState(() {
                                      loading = true;
                                    });
                                    dynamic result = await _auth.signIn(email, password);
                                    if(result == null)
                                    {
                                      setState(() {
                                        error = "could not sign in with above credentials";
                                        loading = false;
                                      });
                                    }
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height:10.0
                            ),
                            InkWell(
                              child:Text("Dont have an account?  Register",
                              style: TextStyle(
                                color: Colors.white
                              ),),
                              onTap: (){
                                widget.toggle();
                              },
                            ),
                            SizedBox(
                              height: 14.0,
                            ),
                            Text(
                              error,
                              style: TextStyle(color: Colors.red,fontSize: 14.0),
                            )
                          ],
                        ),
                    ),
                  ),
              ],
            ),
            ),
      ]
    )
    );
  }
}
