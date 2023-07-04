import 'package:autism_app/screens/learn/dynamic_Object.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class learnScreen extends StatefulWidget {
  late List<CameraDescription> cameras;
  String title;
  learnScreen(this.cameras, this.title);

  @override
  State<learnScreen> createState() => _learnScreenState();
}

class _learnScreenState extends State<learnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Color.fromARGB(249, 85, 81, 53)),
        ),
        centerTitle: true,
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
              ElevatedButton(
                
                onPressed: () {
                  setState(() {
                    Navigator.pushNamed(context, '/static_object');
                  });
                },
                child: Text(
                  'Static ${widget.title}',
                ),
                style: ButtonStyle(),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                dynamicObject(widget.cameras)));
                  });
                },
                child: Text(
                  'Dynamic ${widget.title}',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
