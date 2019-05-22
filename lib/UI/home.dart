import 'package:flutter/material.dart';
import '../util/utils.dart'as util;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;



class WeatherHome extends StatefulWidget {
  @override
  _WeatherHomeState createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  TextEditingController textFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather Home page"),
        
      ),
     
      body: Stack(
        children: <Widget>[
          Image.network("https://images.unsplash.com/photo-1489549132488-d00b7eee80f1?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=334&q=80",
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.fill,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: textFieldController,
              autofocus: true,
              keyboardType: TextInputType.text,
                 style: TextStyle(fontSize: 20,color: Colors.white),
        decoration: InputDecoration(
          labelText: "City Name",
          hintStyle: TextStyle(fontSize: 20.0, color: Colors.white),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.teal,
            ),
          ),
          prefixIcon: const Icon(
            Icons.location_city,
            color: Colors.white,
          ),
        ),
              ),
          ),
          Positioned(
            bottom: 20.0,
            left: 100.0,
            child: Center(
              child: RaisedButton(
                splashColor: Colors.indigoAccent,
                shape: Border.all(color: Colors.white),
                color: Colors.indigo,
                
                
                onPressed: (){
                   _sendDataToSecondScreen(context);
                                 },
                                 child: Text("get weather report",
                                 style: TextStyle(color: Colors.white,),
                                 ),
                               ),
            ),
                           )
                         ],
                       ),
                     );
                   }
                 
                   void _sendDataToSecondScreen(BuildContext context) {
                     String textToSend = textFieldController.text;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherReport(text: textToSend,),
        ));
                   }
}

class WeatherReport extends StatefulWidget {
   final String text;
   WeatherReport({Key key, @required this.text}) : super(key: key);
  @override
  _WeatherReportState createState() => _WeatherReportState();
}

class _WeatherReportState extends State<WeatherReport> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("report"),
      ),
      body: new Stack(
       children: <Widget>[
         new Center(
           child: new Image.network("https://images.unsplash.com/photo-1508898578281-774ac4893c0c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
           height: MediaQuery.of(context).size.height,
           width: MediaQuery.of(context).size.width,
           fit: BoxFit.fill,
           ),
           
         ),
// city name         
         new Container(
           alignment: Alignment.topRight,
           margin: const EdgeInsets.fromLTRB(0.0, 15.9, 20.9, 0.0),
           child: new Text("${widget.text}",
           style: cityStyle(),
         )
         ),
// weather data
  new Container(
    alignment: Alignment.bottomLeft,
    margin: const EdgeInsets.fromLTRB(20.0, 40.0, 0.0, 130),
    child: updateTempWidget("${widget.text}")
    
  )

       ],
     ),


        
      
    );
  }
 Future<Map> getWeather(String appid,String city) async{
   String apiurl= "http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util.apiId}&units=metric";
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
              padding: const EdgeInsets.fromLTRB(8.0,300.0,0.0,0.0),
              child: new Container(
                child: new Column(
                  
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("Current Temp :",
                      style: tempStyle()),
                        Text(content['main']['temp'].toString(),
                      style: tempStyle())
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text("Minimum Temp :",
                      style: tempStyle()),
                        Text(content['main']['temp_min'].toString(),
                      style: tempStyle())
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text("Maximum Temp :",
                      style: tempStyle()),
                        Text(content['main']['temp_max'].toString(),
                      style: tempStyle())
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text("Wind Speed :",
                      style: tempStyle()),
                        Text(content['wind']['speed'].toString(),
                      style: tempStyle())
                      ],
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
    fontSize: 20.9,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    
  );
}


