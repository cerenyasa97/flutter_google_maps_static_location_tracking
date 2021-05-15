import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

List<Map<String, double>> locationList = [
  {"lat": 39.74678, "long": 30.47387},
  {"lat": 39.74713, "long": 30.47389},
  {"lat": 39.74713, "long": 30.47404},
  {"lat": 39.74712, "long": 30.47485},
  {"lat": 39.74854, "long": 30.47484},
  {"lat": 39.75017, "long": 30.4748},
  {"lat": 39.75024, "long": 30.47481},
  {"lat": 39.75032, "long": 30.47481},
  {"lat": 39.75046, "long": 30.47481},
  {"lat": 39.7506, "long": 30.47482},
  {"lat": 39.75089, "long": 30.47483},
  {"lat": 39.75103, "long": 30.47483},
  {"lat": 39.75105, "long": 30.47483},
  {"lat": 39.75129, "long": 30.47482},
  {"lat": 39.75153, "long": 30.47493},
  {"lat": 39.75153, "long": 30.47494},
  {"lat": 39.75154, "long": 30.47496},
  {"lat": 39.75157, "long": 30.47567},
];

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleMapController controller;
  CameraPosition initial = CameraPosition(
      target: LatLng(locationList[0]["lat"], locationList[0]["long"]),
      zoom: 15);
  List<Marker> markerList = [];
  // ignore: close_sinks
  StreamController<List<Marker>> markerStreamController = StreamController<List<Marker>>();
  Stream get markerStream => markerStreamController.stream;
  int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    markerStreamController.sink.add(markerList);
    Timer.periodic(Duration(seconds: 2), (timer) {setMarkers();});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Marker>>(
        stream: markerStream,
        builder: (context, snapshot){
          return GoogleMap(
            initialCameraPosition: initial,
            onMapCreated: (controller) {
              this.controller = controller;

            },
            markers: Set.from(snapshot.data),
          );
        },
      )
    );
  }

  setMarkers() {
    if(index < locationList.length - 2){
      markerList.clear();
      markerList.add(Marker(markerId: MarkerId("live location"), position: LatLng(locationList[index]["lat"], locationList[index]["long"])));
      markerStreamController.add(markerList);
      controller.animateCamera(CameraUpdate.newLatLng(LatLng(locationList[index]["lat"], locationList[index]["long"])));
      index += 1;
    }
  }
}
