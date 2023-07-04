import 'package:autism_app/screens/learn/learn.dart';
import 'package:autism_app/screens/test/test.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class MainScreen extends StatefulWidget {
  String title;
  late List<CameraDescription> _cameras;

  MainScreen(this.title, this._cameras);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Autism',
          style: TextStyle(color: Color.fromARGB(249, 85, 81, 53)),
        ),
        centerTitle: true,
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: const Color.fromARGB(255, 207, 242, 168),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("IMAGES/bg4.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 50,
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  learnScreen(cameras, 'Learn')));
                    });
                  },
                  child: Text(
                    'Learn',
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 7,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  testScreen(widget._cameras)));
                    });
                  },
                  child: const Text(
                    'Test',
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 7,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
