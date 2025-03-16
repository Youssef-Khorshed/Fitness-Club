import 'package:flutter/material.dart';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:model4/widgets/home_screen.dart';
import 'package:model4/widgets/main_screen.dart';

List<CameraDescription>? cameras;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
      home: HomeScreen(cameras!),
      //home: MainScreen(cameras),
      routes: {
        MainScreen.id: (context) => MainScreen(cameras!),
        //DemoScreen.id: (context) => DemoScreen(),
      },
    );
  }
}
