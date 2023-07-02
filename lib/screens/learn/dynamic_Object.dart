import 'dart:ui';
import 'dart:io' as io;
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

class dynamicObject extends StatefulWidget {
  
  

  late List<CameraDescription> cameras;

  dynamicObject(this.cameras);

 

  @override
  _dynamicObjectState createState() => _dynamicObjectState();
}

class _dynamicObjectState extends State<dynamicObject> {
  dynamic controller;
  bool isBusy = false;
  dynamic objectDetector;
  late Size size;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  
  initializeCamera() async {
 
    final modelPath = await _getModel('assets/ml/mobilenet2.tflite');
    final options = LocalObjectDetectorOptions(
      modelPath: modelPath,
      classifyObjects: true,
      multipleObjects: true,
      mode: DetectionMode.stream,
    );
    objectDetector = ObjectDetector(options: options);


    controller = CameraController(widget.cameras[0], ResolutionPreset.high);
    await controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      controller.startImageStream((image) => {
            if (!isBusy)
              {isBusy = true, img = image, doObjectDetectionOnFrame()}
          });
    });
  }


  @override
  void dispose() {
    controller?.dispose();
    objectDetector.close();
    super.dispose();
  }


  dynamic _scanResults;
  CameraImage? img;


  Future<String> _getModel(String assetPath) async {
    if (io.Platform.isAndroid) {
      return 'flutter_assets/$assetPath';
    }
    final path = '${(await getApplicationSupportDirectory()).path}/$assetPath';
    await io.Directory(dirname(path)).create(recursive: true);
    final file = io.File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(assetPath);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }

  doObjectDetectionOnFrame() async {
    var frameImg = getInputImage();
    List<DetectedObject> objects = await objectDetector.processImage(frameImg);
    for (DetectedObject detectedObject in objects) {
      final rect = detectedObject.boundingBox;
      final trackingId = detectedObject.trackingId;

      for (Label label in detectedObject.labels) {
        print('${label.text} ${label.confidence}');
      }
    }

    setState(() {
      _scanResults = objects;
      isBusy = false;
    });
  }

  InputImage getInputImage() {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in img!.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    final Size imageSize = Size(img!.width.toDouble(), img!.height.toDouble());
    final camera = widget.cameras[0];
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation);
   

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(img!.format.raw);
    

    final planeData = img!.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation!,
      inputImageFormat: inputImageFormat!,
      planeData: planeData,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    return inputImage;
  }


  Widget buildResult() {
    if (_scanResults == null ||
        controller == null ||
        !controller.value.isInitialized) {
      return const Text('');
    }

    final Size imageSize = Size(
      controller.value.previewSize!.height,
      controller.value.previewSize!.width,
    );
    CustomPainter painter = ObjectDetectorPainter(imageSize, _scanResults);
    return CustomPaint(
      painter: painter,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stackChildren = [];
    size = MediaQuery.of(context).size;
    if (controller != null) {
      stackChildren.add(
        Positioned(
          top: 0.0,
          left: 0.0,
          width: size.width,
          height: size.height,
          child: Container(
            child: (controller.value.isInitialized)
                ? AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: CameraPreview(controller),
                  )
                : Container(),
          ),
        ),
      );

      stackChildren.add(
        Positioned(
            top: 0.0,
            left: 0.0,
            width: size.width,
            height: size.height,
            child: buildResult()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Object detector"),
        backgroundColor: Color.fromARGB(255, 32, 166, 219),
      ),
      backgroundColor: Colors.black,
      body: Container(
        margin: const EdgeInsets.only(top: 0),
        color: Colors.black,
        child: Stack(
          children: stackChildren,
        ),
      ),
    );
  }
}

class ObjectDetectorPainter extends CustomPainter {
  ObjectDetectorPainter(this.absoluteImageSize, this.objects);

  final Size absoluteImageSize;
  final List<DetectedObject> objects;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.pinkAccent;

    for (DetectedObject detectedObject in objects) {
      canvas.drawRect(
        Rect.fromLTRB(
          detectedObject.boundingBox.left * scaleX,
          detectedObject.boundingBox.top * scaleY,
          detectedObject.boundingBox.right * scaleX,
          detectedObject.boundingBox.bottom * scaleY,
        ),
        paint,
      );

      var list = detectedObject.labels;
      for (Label label in list) {
        print("${label.text}   ${label.confidence.toStringAsFixed(2)}");
        TextSpan span = TextSpan(
            text: label.text,
            style: const TextStyle(
                fontSize: 30, color: Color.fromARGB(255, 255, 255, 255)));
        TextPainter tp = TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(
            canvas,
            Offset(detectedObject.boundingBox.left * scaleX,
                detectedObject.boundingBox.top * scaleY));
        break;
      }
    }
  }

  @override
  bool shouldRepaint(ObjectDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.objects != objects;
  }
}
