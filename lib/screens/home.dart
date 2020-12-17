import 'dart:convert';
import 'package:recipe/models/recipe_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:recipe/shared_code/loading.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:recipe/screens/recipeView.dart';
import 'package:recipe/screens/animations.dart';
import 'package:recipe/screens/recipegrid.dart';
import 'package:nice_button/NiceButton.dart';
import'package:flutter_spinkit/flutter_spinkit.dart';

class home extends StatefulWidget {

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {

  List<Recipe> recipes = [] ;
  String error = "";
  final AuthService _auth = AuthService();
  String appId = "7e968677";
  var firstColor = Color(0xff5b86e5), secondColor = Color(0xff36d1dc);
  String appKey = "631223fc40771e0823e7a6e98df46bff";
  TextEditingController textEditingController = new TextEditingController();
  var response;
  bool loading = false;
  final spinkit = SpinKitDoubleBounce(
    color: Colors.white,
    size: 40.0,
  );
  getRecipes(String value) async
  {
     String url =  "https://api.edamam.com/search?q=$value&app_id=7e968677&app_key=631223fc40771e0823e7a6e98df46bff&calories=591-722";
     response = await http.get(url);
     print("$response is response");
     Map<String,dynamic> json = jsonDecode(response.body);
     json["hits"].forEach((element)
     {
       print(element.toString());
       Recipe recipemodel = new Recipe();
       recipemodel = Recipe.fromMap(element["recipe"]);
       recipes.add(recipemodel);
     });
     return response;
  }
  int length()
  {
    int len = recipes.length;
    return len;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff21254A),
        appBar: AppBar(
          title: Text("Cook Book"),
          centerTitle: true,
          backgroundColor: Color(0xff21254A),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text("Logout"),
              onPressed: () async{
                await _auth.signOut();
              },
            )
          ],
      ),
        body:SingleChildScrollView(
          child: Column(
            children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 30.0,horizontal: 30.0),
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 30.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          child: Column(
                            children: <Widget>[
                              Text("What do you want to cook today?",style: TextStyle(fontSize: 20.0,color: Colors.white),),
                              Text("\nJust enter the ingredient name and we will show the best recipe for you",style: TextStyle(fontSize: 15,color: Colors.white),),
                              SizedBox(
                                height: 20.0,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: TextField(
                                        controller:textEditingController,
                                        style: TextStyle(color: Colors.white),
                                        decoration: new InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black45, width: 1.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.deepPurple[200], width: 1.0),
                                          ),
                                          labelText: "Enter Ingredient",
                                          labelStyle: TextStyle(
                                            color: Colors.white,
                                          ),
                                          fillColor: Colors.white,
                                          //fillColor: Colors.green
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Center(
                                child: RaisedButton(
                                  textColor: Colors.white,
                                  color: Colors.black,
                                  onPressed: () async{
                                    FocusScope.of(context).unfocus();
                                    if(textEditingController.text.isNotEmpty)
                                    {
                                      recipes=[];
                                      setState(() {
                                        loading = true;
                                      });
                                      var result = await getRecipes(textEditingController.text);
                                      print(result);
                                      if(result!=null)
                                      {
                                        setState(() {
                                          loading = false;
                                        });
                                      }
                                      else if(recipes.length == 0)
                                      {
                                        setState(() {
                                          error = "Sorry! Could not fetch any recipes";
                                          loading = false;
                                        });
                                      }
                                    }
                                    else
                                    {
                                      print("Just dont do it");
                                    }
                                  },
                                  child: Text("Search"),
                                  shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(30.0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                error,
                                style: TextStyle(color: Colors.red,fontSize: 14.0),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height:40.0
                        ),
                        loading ? spinkit:FadeAnimation(1,
                          Container(
                          decoration:BoxDecoration(borderRadius: BorderRadius.circular(20)),
                          child: GridView(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: ClampingScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              mainAxisSpacing: 10
                            ),
                              children: List.generate(recipes.length, (index) {
                                return GridTile(
                                    child: RecipeTile(
                                      title: recipes[index].label,
                                      imgUrl: recipes[index].image,
                                      desc: recipes[index].source,
                                      url: recipes[index].url,
                                    ),
                                );
                              })),
                        ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
        ),
      );
  }
}

class RecipeTile extends StatefulWidget {
  final String title, desc, imgUrl, url;

  RecipeTile({this.title, this.desc, this.imgUrl, this.url});

  @override
  _RecipeTileState createState() => _RecipeTileState();
}

class _RecipeTileState extends State<RecipeTile> {
  _launchURL(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        GestureDetector(
          onTap: () {
              print(widget.url + " this is what we are going to see");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>  Recipeview(
                        postUrl: widget.url,
                      )));
          },
          child: Container(
            margin: EdgeInsets.all(8),
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    ),
    child: Stack(
              children: <Widget>[
                Image.network(
                  widget.imgUrl,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: 200,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white30, Colors.white],
                          begin: FractionalOffset.centerRight,
                          end: FractionalOffset.centerLeft),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              fontFamily: 'Overpass'),
                        ),
                        Text(
                          widget.desc,
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                              fontFamily: 'OverpassRegular'),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
