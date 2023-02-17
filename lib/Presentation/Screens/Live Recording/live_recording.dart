import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:silarec/Services/SignVidClassifier.dart';

typedef convert_func = Pointer<Uint32> Function(
    Pointer<Uint8>, Pointer<Uint8>, Pointer<Uint8>, Int32, Int32, Int32, Int32);
typedef Convert = Pointer<Uint32> Function(
    Pointer<Uint8>, Pointer<Uint8>, Pointer<Uint8>, int, int, int, int);

class LiveRecording extends StatelessWidget {
  Widget build(BuildContext context) {
    return CameraPage();
  }

  String get_title() => "Live Recording";
}

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isLoading = true;
  bool _isRecording = false;

  late CameraController _cameraController;

  late SignVidClassifier _classifier;
  CameraImage? _currentImage;

  Category? _category;

  final DynamicLibrary convertImageLib = Platform.isAndroid
      ? DynamicLibrary.open("libconvertImage.so")
      : DynamicLibrary.process();
  late Convert conv;

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _classifier = SignVidClassifier(numThreads: 4);

    // Load the convertImage() function from the library
    conv = convertImageLib
        .lookup<NativeFunction<convert_func>>('convertImage')
        .asFunction<Convert>();

    super.initState();
    _initCamera();
  }

  _initCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);
    _cameraController = CameraController(front, ResolutionPreset.low);
    await _cameraController.initialize();

    setState(() => _isLoading = false);
  }

  _recordVideo() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isRecording) {
        timer.cancel();
      }
      if (_currentImage != null) {
        getPrediction(_currentImage!);
      }
    });

    if (_isRecording) {
      _cameraController.stopImageStream();
      setState(() => _isRecording = false);
    } else {
      setState(() => _isRecording = true);
      _cameraController.startImageStream((image) async {
        setState(() {
          _currentImage = image;
        });
      });
    }
  }

  getPrediction(CameraImage image) {
    // Allocate memory for the 3 planes of the image
    Pointer<Uint8> p = malloc.allocate<Uint8>(image.planes[0].bytes.length);
    Pointer<Uint8> p1 = malloc.allocate<Uint8>(image.planes[1].bytes.length);
    Pointer<Uint8> p2 = malloc.allocate<Uint8>(image.planes[2].bytes.length);

    // Assign the planes data to the pointers of the image
    Uint8List pointerList = p.asTypedList(image.planes[0].bytes.length);
    Uint8List pointerList1 = p1.asTypedList(image.planes[1].bytes.length);
    Uint8List pointerList2 = p2.asTypedList(image.planes[2].bytes.length);
    pointerList.setRange(
        0, image.planes[0].bytes.length, image.planes[0].bytes);
    pointerList1.setRange(
        0, image.planes[1].bytes.length, image.planes[1].bytes);
    pointerList2.setRange(
        0, image.planes[2].bytes.length, image.planes[2].bytes);

    // Call the convertImage function and convert the YUV to RGB
    Pointer<Uint32> imgP = conv(p, p1, p2, image.planes[1].bytesPerRow,
        image.planes[1].bytesPerPixel!, image.width, image.height);
    // Get the pointer of the data returned from the function to a List
    Uint32List imgData = imgP.asTypedList((image.width * image.height));

    // Generate image from the converted data
    img.Image preprocessed_img =
        img.Image.fromBytes(image.height, image.width, imgData);

    // Free the memory space allocated
    // from the planes and the converted data
    malloc.free(p);
    malloc.free(p1);
    malloc.free(p2);
    malloc.free(imgP);

    // final imag = Image.memory(preprocessed_img.getBytes(format: img.Format.rgb),
    //     height: image.height.toDouble(), width: image.width.toDouble());

    // final m = Image.memory(img.encodeJpg(preprocessed_img) as Uint8List);
    // final imag = img.Image.fromBytes(image.width, image.height,
    //     img.encodeJpg(preprocessed_img) as Uint8List);

    // var pred = _classifier.predict(imag);
    var pred = _classifier.predict(preprocessed_img);

    setState(() {
      // showDialog(
      //     context: context,
      //     builder: ((context) => Dialog(
      //           insetAnimationDuration: const Duration(seconds: 10),
      //           child:
      //               Image.memory(img.encodeJpg(preprocessed_img) as Uint8List),
      //         )));
      _category = pred;

      // print('');
      // print('**************************************');
      // print(pred.label);
      // print(pred.score);
      // print('***************************************');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      var height = (MediaQuery.of(context).size.height / 3) * 2;
      var width = MediaQuery.of(context).size.width;
      return Center(
        child: Column(
          children: [
            SizedBox(
                height: height,
                width: width,
                child: CameraPreview(_cameraController)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Start Translation"),
                FloatingActionButton(
                    child: Icon(
                      Icons.camera,
                      color: _isRecording ? Colors.red : Colors.green,
                    ),
                    onPressed: () => _recordVideo()),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            _category != null
                ? Text(
                    'Prediction: ${_category!.label}   Confidence: ${_category!.score}')
                : const Text('')
          ],
        ),
      );
    }
  }
}

// img.Image convertCameraImageToImage(CameraImage cameraImage) {
//   // Concatenate the planes of the CameraImage.
//   final bytes = _concatenatePlanes(cameraImage.planes);

//   // Create an Image from the bytes using the image package.
//   final image =
//       img.Image.fromBytes(cameraImage.width, cameraImage.height, bytes);

//   return image;
// }

// Uint8List _concatenatePlanes(List<Plane> planes) {
//   final List<Uint8List> allBytes = <Uint8List>[];
//   int totalSize = 0;

//   for (Plane plane in planes) {
//     allBytes.add(plane.bytes);
//     totalSize += plane.bytes.length;
//   }

//   final Uint8List concatenatedBytes = Uint8List(totalSize);
//   int concatenatedBytesIndex = 0;
//   for (Uint8List bytes in allBytes) {
//     concatenatedBytes.setRange(
//         concatenatedBytesIndex, concatenatedBytesIndex + bytes.length, bytes);
//     concatenatedBytesIndex += bytes.length;
//   }

//   return concatenatedBytes;
// }

// img.Image _normalizeCameraImage(CameraImage cameraImage) {
//   // Convert the CameraImage to an Image.
//   final image = convertCameraImageToImage(cameraImage);

//   // Resize the Image to the input size of the model.
//   final resized = img.copyResize(image, width: 64, height: 64);

//   // Normalize the pixels of the Image to the range [0, 1].
//   return img.normalize(resized, 0, 1);

//   // Convert the normalized Image to a Uint8List of RGB bytes.
//   // final bytes = List.generate(
//   //     normalized.length, (i) => (normalized[i] * 255).round().clamp(0, 255));

//   // return
// }

// img.Image convertYUV420ToImage(CameraImage cameraImage) {
//   final width = cameraImage.width;
//   final height = cameraImage.height;

//   final yRowStride = cameraImage.planes[0].bytesPerRow;
//   final uvRowStride = cameraImage.planes[1].bytesPerRow;
//   final uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

//   final image = img.Image(width, height);
//   // return image;
//   for (var w = 0; w < width; w++) {
//     for (var h = 0; h < height; h++) {
//       final uvIndex =
//           uvPixelStride * (w / 2).floor() + uvRowStride * (h / 2).floor();
//       final index = h * width + w;
//       final yIndex = h * yRowStride + w;

//       final y = cameraImage.planes[0].bytes[yIndex];
//       final u = cameraImage.planes[1].bytes[uvIndex];
//       final v = cameraImage.planes[2].bytes[uvIndex];

//       image.data[index] = yuv2rgb(y, u, v);
//     }
//   }
//   return image;
// }

// int yuv2rgb(int y, int u, int v) {
//   // Convert yuv pixel to rgb
//   var r = (y + v * 1436 / 1024 - 179).round();
//   var g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
//   var b = (y + u * 1814 / 1024 - 227).round();

//   // Clipping RGB values to be inside boundaries [ 0 , 255 ]
//   r = r.clamp(0, 255);
//   g = g.clamp(0, 255);
//   b = b.clamp(0, 255);

//   return 0xff000000 | ((b << 16) & 0xff0000) | ((g << 8) & 0xff00) | (r & 0xff);
// }
