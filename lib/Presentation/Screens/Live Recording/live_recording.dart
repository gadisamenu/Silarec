import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class LiveRecording extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: const Text("Live Recording")),
    );
  }

  String get_title() => "Live Recording";
}

// import 'package:camera/camera.dart';
// import 'package:flutter_tflite/flutter_tflite.dart';

// class LiveRecording extends StatefulWidget {
//   @override
//   _LiveRecordingState createState() => _LiveRecordingState();

//   String get_title() => "Live Recording";
// }

// class _LiveRecordingState extends State<LiveRecording> {
//   late List<CameraDescription> cameras;
//   late CameraController controller;
//   bool isInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     initializeCamera();
//     initializeTfliteModel();
//   }

//   void initializeCamera() async {
//     cameras = await availableCameras();
//     controller = CameraController(cameras[0], ResolutionPreset.medium);
//     await controller.initialize();
//     setState(() {
//       isInitialized = true;
//     });
//   }

//   void initializeTfliteModel() async {
//     await Tflite.loadModel(
//         model: 'assets/model.tflite', labels: 'assets/labels.txt');
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     Tflite.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!isInitialized) {
//       return Container();
//     }

//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         CameraPreview(controller),
//         FloatingActionButton(
//           onPressed: () {
//             processImage();
//           },
//           child: Icon(Icons.camera),
//         ),
//       ],
//     );
//   }

//   void processImage() async {
//     // Take a picture
//     final image = await controller.takePicture();

//     // Preprocess the image
//     final preprocessedImage = await preprocessImage(image);

//     // Run the model inference
//     final results =
//         await Tflite.runModelOnBinary(binary: preprocessedImage, numResults: 1);

//     // Process the model's predictions
//     final prediction = results![0]['label'];
//     print('The model predicts: $prediction');
//   }

//   Future<Uint8List> preprocessImage(XFile image) async {
//     // Resize the image
//     final resizedImage = Image(image: FileImage(File(image.path)));
//         .image
//         .resolve(ImageConfiguration())
//         .addListener(ImageStreamListener(
//             (ImageInfo info, bool _) => completer.complete(info.image)));
//     final resizedImageBytes =
//         Uint8List.view((await resizedImage.toByteData()).buffer);

//     // Normalize the pixel values
//     final normalizedImageBytes = List<double>.from(resizedImageBytes)
//         .map((pixel) => pixel / 255.0)
//         .toList();
//   }
// }
