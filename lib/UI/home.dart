import 'package:flutter/material.dart';
import '../util/utils.dart'as util;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;



class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  var _textController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: new Text("Weather App"),
      ),
      body: new Center(
        child: Column(
          children: <Widget>[
            new ListTile(
            title: new TextField(
              decoration: InputDecoration(
                hintText: "city name",
                border: OutlineInputBorder()
              ),
              controller: _textController,
            ),
          ),
            RaisedButton(child: Text("see the weather report"),
            onPressed: (){
              var route = new MaterialPageRoute(
                  builder: (BuildContext context) =>
                      new MyHomePage(value: _textController.text),
                );
                Navigator.of(context).push(route);
            },)
          ],
        ),
      ),
    );
  }
}





























class MyHomePage extends StatefulWidget {
  final String value;

  MyHomePage({Key key, this.value}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       
        centerTitle: true,
  title: Text('Weather App'),
),
     body: new Stack(
       children: <Widget>[
         new Center(
           child: new Image.asset("images/p1.jpg",
           height: MediaQuery.of(context).size.height,
           width: MediaQuery.of(context).size.width,
           fit: BoxFit.fill,
           ),
           
         ),
// city name         
         new Container(
           alignment: Alignment.topRight,
           margin: const EdgeInsets.fromLTRB(0.0, 15.9, 20.9, 0.0),
           child: new Text("${widget.value}",
           style: cityStyle(),
         )
         ),
// weather data
  new Container(
    alignment: Alignment.bottomLeft,
    margin: const EdgeInsets.fromLTRB(12.0, 0.0, 0.0, 130),
    child: updateTempWidget("${widget.value}")
    
  )

       ],
     ),


        
      
    );
  }
 Future<Map> getWeather(String appid,String city) async{
   String apiurl= "http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util.apiId}&units=imperial";
   http.Response response = await http.get(apiurl);
    return json.decode(response.body);
 }
 Widget updateTempWidget(String city){
   return new FutureBuilder(
     future: getWeather(util.apiId, city==null?util.defaultcity:city),
     builder: (BuildContext context,AsyncSnapshot<Map> snapshot){
        // all info will be received here 
        if(snapshot.hasData){
          Map content = snapshot.data;
          return Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0,200.0,0.0,0.0),
              child: new Container(
                child: new Column(
                  
                  children: <Widget>[
                    new ListTile(
                      title: new Text(content['main']['temp'].toString(),
                      style: tempStyle(),
                      ),
                    ), new ListTile(
                      title: new Text(content['main']['temp_min'].toString(),
                      style: tempStyle(),
                      ),
                    ),
                    new ListTile(
                      title: new Text(content['main']['temp_max'].toString(),
                      style: tempStyle(),
                      ),
                    ),
                     new ListTile(
                      title: new Text(content['wind']['speed'].toString(),
                      style: tempStyle(),
                      ),
                    ),
                    
                  ],
                ),
              ),
            ),
          );
        }else{
          return new Container();
        }
     },
   );
 }

}


class ChangeCity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  new Scaffold(appBar: AppBar(
      backgroundColor:Colors.transparent,
      title: Text("change  city"),
      centerTitle: true,
    ),
      body: new Stack(
        children: <Widget>[
          new ListView(
            children: <Widget>[
              new Image.asset("images/p1/jpg",
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fill,
              ),
              
            ],
          )
        ],
      ),
    );
  }
}

TextStyle cityStyle(){
  return new TextStyle(
    color: Colors.white,
    fontSize: 22.9,
    fontStyle: FontStyle.italic,
  );
}

TextStyle tempStyle(){
  return new TextStyle(
    color: Colors.white,
    fontSize: 30.9,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    
  );
}







 




