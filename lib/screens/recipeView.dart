import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:recipe/shared_code/loading.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class Recipeview extends StatefulWidget {

  String postUrl;
  Recipeview({this.postUrl});

  @override
  _RecipeviewState createState() => _RecipeviewState();
}

class _RecipeviewState extends State<Recipeview> {

  String url;
  final _key = UniqueKey();
  bool _isLoadingPage;
  bool showErrorPage = false;
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  StreamSubscription<WebViewStateChanged> _onchanged;

  @override

  void initState()
  {
    if(widget.postUrl.contains("http://"))
      {
        url = widget.postUrl.replaceAll("http://", "https://");
      }
    else
      {
        url = widget.postUrl;
      }
    super.initState();
    _isLoadingPage = true;
    _onchanged = flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {
        if(state.type== WebViewState.finishLoad){ // if the full website page loaded
          print("loaded...");
        }else if (state.type== WebViewState.abortLoad){ // if there is a problem with loading the url
          print("there is a problem...");
        } else if(state.type== WebViewState.startLoad){ // if the url started loading
          print("start loading...");
        }
      }
    });

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    flutterWebviewPlugin.dispose(); // disposing the webview widget
  }


  Widget build(BuildContext context) {
    return WebviewScaffold(
        url: url,
        withJavascript: false, // run javascript
        withZoom: false, // if you want the user zoom-in and zoom-out
        hidden: true , // put it true if you want to show CircularProgressIndicator while waiting for the page to load

        appBar: AppBar(
          title: Text("Cook Book"),
          centerTitle: true,
          backgroundColor: Color(0xff21254A),
          elevation: 1, // give the appbar shadows
          iconTheme: IconThemeData(color: Colors.white),
          actions: <Widget>[
            InkWell(
              child: Icon(Icons.refresh),
              onTap: (){
                flutterWebviewPlugin.reload();
                // flutterWebviewPlugin.reloadUrl(); // if you want to reloade another url
              },
            ),
          ],
        ),
        initialChild: Container( // but if you want to add your own waiting widget just add InitialChild
          color: Colors.white,
          child: const Center(
            child: CircularProgressIndicator(),
          ),)
    );
  }
}