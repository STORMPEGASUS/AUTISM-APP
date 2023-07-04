import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../learn/learn.dart';
import 'dynamic_Image.dart';

class testScreen extends StatefulWidget {
  late List<CameraDescription> _cameras;

  testScreen(this._cameras);

  @override
  State<testScreen> createState() => _testScreenState();
}

class _testScreenState extends State<testScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Test',
          style: TextStyle(color: Color.fromARGB(249, 85, 81, 53)),
        ),
        centerTitle: true,
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: Color.fromARGB(255, 207, 242, 168),
      ),
      body: Container(
        decoration: const BoxDecoration(
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
              Container(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pushNamed(context, '/static_Image');
                    });
                  },
                  child: const Text(
                    'Static Test',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  dynamicImage(widget._cameras)));
                    });
                  },
                  child: const Text(
                    'Dynamic Test',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => learnScreen(
                                  widget._cameras, 'Check Result')));
                    });
                  },
                  child: const Text(
                    'Check Result',
                    style: TextStyle(fontSize: 20),
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
