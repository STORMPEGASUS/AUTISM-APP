import 'package:autism_app/mainScreen.dart';
import 'package:autism_app/screens/learn/learn.dart';
import 'package:autism_app/screens/learn/static_Object.dart';

import 'package:autism_app/screens/test/static_Image.dart';
import 'package:autism_app/screens/test/test.dart';
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';

late List<CameraDescription> cameras;
late List<CameraDescription> _cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  _cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  String title = "Learn";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("IMAGES/bg3.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: <Widget>[
            const Positioned(
              bottom: 120,
              left: 15,
              right: 30,
              child: Text(
                'Introducing "Learn & Test Autism Aid," an inclusive app empowering individuals with autism to learn, test, and succeed through personalized content, adaptive testing, and accessibility features.',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
            ),
            Positioned(
              left: 15,
              right: 30,
              bottom: 60,
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MainScreen('Autism', _cameras)));
                    });
                  },
                  child: Text('Explore')),
            ),
          ],
        ),
      ),
    );
  }
}
