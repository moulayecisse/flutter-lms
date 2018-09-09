import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(new LMSApp());

class LMSApp extends StatefulWidget
{
  @override
  State<StatefulWidget> createState()
  {
    return new LMSState();
  }
}

class LMSState extends State<LMSApp>
{
  var _isLoading = true;
  var videos;

  _fetchData() async
  {
    final url = "https://api.letsbuildthatapp.com/youtube/home_feed";
    final response = await http.get(url);

    if( response.statusCode == 200 ){
      final map = json.decode(response.body);
      final videoJson = map["videos"];

//      videoJson.forEach(
//        (video) {
//          print(video["name"]);
//        }
//      );

      setState(() {
        _isLoading = false;
        this.videos = videoJson;
      });
    }
  }

  _switchLoading(){
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("LMS | Library Management System"),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.refresh),
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                  });
                  _fetchData();
                }
            )
          ],
        ),
        body: new Center(
          child: _isLoading ?
            new CircularProgressIndicator() :
            new ListView.builder(
              itemCount: this.videos != null ? this.videos.length : 0,
              itemBuilder: (context, i){
                return new Text("Row: $i");
              },

            )
        ),
      ),
    );
  }
}