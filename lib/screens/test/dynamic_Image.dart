import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';




class dynamicImage extends StatefulWidget {
  
   late List<CameraDescription> _cameras;

  dynamicImage(this._cameras);
  @override
  State<dynamicImage> createState() => _dynamicImageState();
}

class _dynamicImageState extends State<dynamicImage> {
  late CameraController controller;

  String result = "results to be shown here";

  
  dynamic imageLabeler;
  bool isBusy = false;
  @override
  void initState() {
    super.initState();
    
    final ImageLabelerOptions options =
        ImageLabelerOptions(confidenceThreshold: 0.6);
    imageLabeler = ImageLabeler(options: options);
   
    controller = CameraController(widget._cameras[0], ResolutionPreset.high);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      controller.startImageStream((image) => {
            if (isBusy == false) {img = image, doImageLabeling(), isBusy = true}
          });
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }

  doImageLabeling() async {
    result = "";
    InputImage inputImage = getInputImage();
    final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
    result = "";
    for (ImageLabel label in labels) {
      final String text = label.label;
      final int index = label.index;
      final double confidence = label.confidence;
      result += "$text    ${confidence.toStringAsFixed(2)}\n";
    }
    setState(() {
      result;
    });
    isBusy = false;
  }

  CameraImage? img;
  InputImage getInputImage() {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in img!.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(img!.width.toDouble(), img!.height.toDouble());

    final camera = widget._cameras[0];
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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(controller),
          Container(
            margin: const EdgeInsets.only(left: 10, bottom: 10),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                result,
                style: const TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          )
        ],
      ),
    );
  }
}
