import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:untitled/geolocate.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/services.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "App",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;
  String? currentPosition;
  Stream<GyroscopeEvent>? _gyroscopeStream;
  GyroscopeEvent? _gyroscopeEvent;
  String orientation = '';



  @override
  void initState() {
    super.initState();
    _gyroscopeStream = gyroscopeEvents;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          title: Text(
              widget.title
          ),
        ),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.location_on),
              label: 'Геолокация',
            ),
            NavigationDestination(
              icon: Icon(Icons.screen_rotation),
              label: 'Гироскоп',
            ),
            NavigationDestination(
              icon: Icon(Icons.adb),
              label: 'Зыркай что-то еще',
            ),
          ],
        ),
        body: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FutureBuilder(
                  future: determinePosition(),
                  builder: (context, snapshot) {
                    if (currentPosition != null) {
                      return Text(
                        currentPosition!,
                        textAlign: TextAlign.center,
                      );
                    }
                    if (snapshot.hasData){
                      currentPosition = snapshot.data.toString();
                      return Text(
                        snapshot.data.toString(),
                        textAlign: TextAlign.center,
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
          ),
          Center(
            child: StreamBuilder<GyroscopeEvent>(
              stream: _gyroscopeStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _gyroscopeEvent = snapshot.data;
                }
                return Center(
                  child: Text(
                      "X: ${_gyroscopeEvent?.x.toStringAsFixed(2)}\n"
                          "Y: ${_gyroscopeEvent?.y.toStringAsFixed(2)}\n"
                          "Z: ${_gyroscopeEvent?.z.toStringAsFixed(2)}\n"
                  ),
                );
              },
            ),

          ),
          const Center(
            child: Text('Представьте, что здесь прыгают овечки'),
          )
        ][currentPageIndex]
    );
  }
}
