import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:silarec/Services/landmark_detection/hand_detection.dart';
import 'package:silarec/Services/landmark_detection/pose_detection.dart';
import 'package:silarec/Services/sign_lang_recog/sign_lang_recognition.dart';

import 'package:image/image.dart' as img_lib;

class ExampleVideo extends StatefulWidget {
  String url;
  ExampleVideo({Key? key, required this.url}) : super(key: key);

  @override
  _ExampleVideoState createState() => _ExampleVideoState();
}

class _ExampleVideoState extends State<ExampleVideo> {
  late VlcPlayerController controller;

  late HandDetector handDetector = HandDetector();
  late PoseDetector poseDetector = PoseDetector();
  late SignLanguageDetector silangDetector = SignLanguageDetector();

  Image? _image;

  @override
  void initState() {
    controller = VlcPlayerController.asset(widget.url,
        options: VlcPlayerOptions(), autoInitialize: true);

    Timer.periodic(const Duration(seconds: 2), (timer) async {
      Uint8List image = await controller.takeSnapshot();
      setState(() {
        // _image = Image.memory(image);

        // Tflite.runModelOnBinary(binary: image);
        // print(
        //     '${_image!.width}*********************************************88888888888888888888888888');

        // if (_image != null) {
        //   List<double>? results = handDetector.runHandDetector(
        //       image, _image!.width!.toInt(), _image!.height!.toInt());
        //   if (results != null) {
        //     print('***************${results.length}');
        //   } else {
        //     print('nulllllllllllllllllllllllllllllllllllllllllll');
        //   }
        // }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          children: [
            Container(
              height: 500,
              child: VlcPlayer(
                aspectRatio: controller.value.aspectRatio,
                controller: controller,
                placeholder: const Center(child: CircularProgressIndicator()),
              ),
            ),
            _image != null ? _image! : const Text('NULL')
          ],
        );
      },
    );
  }
}
