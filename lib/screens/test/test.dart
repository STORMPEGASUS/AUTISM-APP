import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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
        title: const Text('Test'),
        centerTitle: true,
         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                setState(() {
                  Navigator.pushNamed(context, '/static_Image');
              
                });
              },
              child: const Text(
                'Static Test',
              ),
            ),
            ElevatedButton(
              onPressed: (){
                setState(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => dynamicImage(widget._cameras)));
                });
              },
              child: const Text(
                'Dynamic Test',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
