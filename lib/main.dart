import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Map _data;
List _features;
void main() async {

  _data = await getQuakes();
  _features=_data['features'];

  runApp(new MaterialApp(
    title: "Quakes",
    home: new Quakes(),
  ));
}

class Quakes  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return new Scaffold(
     appBar: AppBar(
       title: new Text('Quakes'),
       centerTitle: true,
       backgroundColor: Colors.red,
     ),
     body: new Center(
       child: new ListView.builder(
         itemCount: _features.length,
           padding: new EdgeInsets.all(16.0),
           itemBuilder: (BuildContext context,int position){

           //crating our listview
             if(position.isOdd)return new Divider();
             final index=position ~/ 2; //we are dividing position by 2 and returning the integer result

//             var format=new DateFormat.yMMMd("en_us").add_jm();
//             var date=format.format(new DateTime.fromMicrosecondsSinceEpoch(_features[index]['properties']['time']*1000,
//             isUtc: true));

             return new ListTile(
               title: new Text("At:${_features[index]['properties']['time']}",
               style: new TextStyle(fontSize: 15.5,
               color: Colors.orange,fontWeight: FontWeight.w500),
               ),
               subtitle: new Text("${_features[index]['properties']['place']}",
               style: new TextStyle(fontSize: 14.5,
               fontWeight: FontWeight.normal,
               color: Colors.grey,
               fontStyle: FontStyle.italic),),

               leading: new CircleAvatar(
                 backgroundColor: Colors.red,
                 child: new Text("${_features[index]['properties']['mag']}",
                 style: new TextStyle(
                   fontSize: 14.5,
                   fontWeight: FontWeight.bold,
                   color: Colors.white,
                   fontStyle: FontStyle.normal
                 ),),
               ),
               onTap: (){_showAlertMessage(context,"${_features[index]['properties']['title']}");},
             );
           }),
     ),
   );
  }

  void _showAlertMessage(BuildContext context, String message) {
    var alert=AlertDialog(
      title: new Text("Quakes"),
      content: new Text(message),
      actions: <Widget>[
        new FlatButton(onPressed: (){Navigator.pop(context);},
            child: new Text('Ok'))
      ],
    );
    showDialog(context: context,child: alert);
  }
}


Future<Map> getQuakes() async {
  String apiUrl='https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson';
  http.Response response=await http.get(apiUrl);
  return jsonDecode(response.body); // return a list type
}