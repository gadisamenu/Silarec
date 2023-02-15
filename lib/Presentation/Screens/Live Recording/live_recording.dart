import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

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
      await _cameraController.startImageStream((image) => null);
      setState(() => _isRecording = true);
    }
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
