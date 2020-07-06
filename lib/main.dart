import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'dart:async';
import 'dart:io';

void main() {
  runApp(MaterialApp(home: SenseMotion()));
}

bool stop = true;
var time;

UserAccelerometerEvent data1;
AccelerometerEvent data2;
GyroscopeEvent data3;

class SenseMotion extends StatefulWidget {
  @override
  _SenseMotionState createState() => _SenseMotionState();
}

class _SenseMotionState extends State<SenseMotion> {
  void server() async {
    print("k");
    var server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
    try {
      await for (var request in server) {
        request.response.headers.contentType = ContentType.text;
        (stop)
            ? request.response.write(data1.x.toString() +
                " " +
                data1.y.toString() +
                " " +
                data1.z.toString() +
                " " +
                data2.x.toString() +
                " " +
                data2.y.toString() +
                " " +
                data2.z.toString() +
                " " +
                data3.x.toString() +
                " " +
                data3.y.toString() +
                " " +
                data3.z.toString())
            : request.response.write("closed");
        request.response.close();
      }
    } catch (error) {
      print(error);
    }
  }

  void readData() {
    userAccelerometerEvents.listen((event) {
      data1 = event;
    });
    accelerometerEvents.listen((event) {
      data2 = event;
    });
    gyroscopeEvents.listen((event) {
      data3 = event;
    });

    Timer.periodic(Duration(seconds: 1), (timer) {
      print("Accel: $data1.");
      print("Gyro: $data2");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          color: Colors.purple,
          child: Text(
            "Start",
            style: TextStyle(fontSize: 20),
          ),
          onPressed: () {
            stop = true;
            readData();
            server();
          },
        ),
        RaisedButton(
          color: Colors.purple,
          child: Text(
            "Stop",
            style: TextStyle(fontSize: 20),
          ),
          onPressed: () {
            stop = false;
          },
        )
      ],
    );
  }
}
