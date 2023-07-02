import 'package:autism_app/screens/learn/dynamic_Object.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

//import 'test/dynamic_Image.dart';

class learnScreen extends StatefulWidget {
   late List<CameraDescription> cameras;

  learnScreen(this.cameras);

  

  @override
  State<learnScreen> createState() => _learnScreenState();
}

class _learnScreenState extends State<learnScreen> {
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
                  Navigator.pushNamed(context, '/static_object');
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => dynamicImage(_cameras)));
                });
              },
              child: Text(
                'Static Learn',
              ),
            ),
            ElevatedButton(
              onPressed: (){
                setState(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => dynamicObject(widget.cameras)));
                });
              },
              child: Text(
                'Dynamic Learn',
              ),
            ),
          ],
        ),
      ),
    );
  }
}