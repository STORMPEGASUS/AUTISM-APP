import 'package:autism_app/screens/learn/dynamic_Object.dart';
import 'package:autism_app/screens/learn/learn.dart';
import 'package:autism_app/screens/learn/static_Object.dart';

import 'package:autism_app/screens/test/dynamic_Image.dart';
import 'package:autism_app/screens/test/static_Image.dart';
import 'package:autism_app/screens/test/test.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

import 'package:camera/camera.dart';

late List<CameraDescription> cameras;
late List<CameraDescription> _cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  _cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
      routes: {
        staticObject.routename: (context) => staticObject(),
        staticImage.routename: (context) => staticImage(),

      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Autism'),
        centerTitle: true,
        
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Navigator.pushNamed(context, '/static_object');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => learnScreen(cameras)));
                });
              },
              child: Text(
                'Learn',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => testScreen(_cameras)));
                });
              },
              child: Text(
                'Test',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
