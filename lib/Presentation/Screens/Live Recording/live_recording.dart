
import 'package:image/image.dart' as img;

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:silarec/Services/SignVidClassifier.dart';

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

  final SignVidClassifier _classifier = SignVidClassifier();
  
  Category? _category;

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  _initCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);
    _cameraController = CameraController(front, ResolutionPreset.max);
    await _cameraController.initialize();

    setState(() => _isLoading = false);
  }

  _recordVideo() async {
    if (_isRecording) {
      await _cameraController.stopImageStream();
      setState(() => _isRecording = false);
    } else {
      await _cameraController.startImageStream((image) => getPrediction(image));
      setState(() => _isRecording = true);
    }
  }

  getPrediction(CameraImage image) {
    var pred = _classifier.predict(convertYUV420ToImage(image));

    setState(() {
      _category = pred;
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
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 15),
              color: Theme.of(context).colorScheme.primary,
              child: const Text(
                  textAlign: TextAlign.center,
                  'This is the transcription of the sign language'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text('Time'),
                FloatingActionButton(
                    child: Icon(
                      Icons.record_voice_over,
                      color: _isRecording ? Colors.red : Colors.green,
                    ),
                    onPressed: () => _recordVideo())
              ],
            ),
          ],
        ),
      );
    }
  }
}



img.Image convertYUV420ToImage(CameraImage cameraImage) {
    final width = cameraImage.width;
    final height = cameraImage.height;

    final yRowStride = cameraImage.planes[0].bytesPerRow;
    final uvRowStride = cameraImage.planes[1].bytesPerRow;
    final uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    final image = img.Image(width, height);

    for (var w = 0; w < width; w++) {
      for (var h = 0; h < height; h++) {
        final uvIndex =
            uvPixelStride * (w / 2).floor() + uvRowStride * (h / 2).floor();
        final index = h * width + w;
        final yIndex = h * yRowStride + w;

        final y = cameraImage.planes[0].bytes[yIndex];
        final u = cameraImage.planes[1].bytes[uvIndex];
        final v = cameraImage.planes[2].bytes[uvIndex];

        image.data[index] = yuv2rgb(y, u, v);
      }
    }
    return image;
  }

int yuv2rgb(int y, int u, int v) {
  // Convert yuv pixel to rgb
  var r = (y + v * 1436 / 1024 - 179).round();
  var g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
  var b = (y + u * 1814 / 1024 - 227).round();

  // Clipping RGB values to be inside boundaries [ 0 , 255 ]
  r = r.clamp(0, 255);
  g = g.clamp(0, 255);
  b = b.clamp(0, 255);

  return 0xff000000 |
      ((b << 16) & 0xff0000) |
      ((g << 8) & 0xff00) |
      (r & 0xff);
}