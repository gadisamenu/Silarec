import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:go_router/go_router.dart';
import 'package:silarec/Services/SignVidClassifier.dart';

import 'package:image/image.dart' as img;
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class ExampleVideo extends StatefulWidget {
  String url;
  File? file;
  var video;

  ExampleVideo({Key? key, this.file, required this.url}) : super(key: key);

  @override
  _ExampleVideoState createState() => _ExampleVideoState();
}

class _ExampleVideoState extends State<ExampleVideo> {
  late VlcPlayerController controller;

  late SignVidClassifier _classifier;
  bool _isPlaying = false;
  Category? _category;

  img.Image? _currentImage;

  @override
  void initState() {
    _classifier = SignVidClassifier(numThreads: 4);

    if (widget.file != null) {
      controller = VlcPlayerController.file(widget.file!,
          options: VlcPlayerOptions(), autoPlay: false);
    } else {
      controller = VlcPlayerController.asset(widget.url,
          options: VlcPlayerOptions(), autoPlay: false);
    }
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  getPrediction(img.Image image) {
    var pred = _classifier.predict(image);

    setState(() {
      _category = pred;
    });
  }

  _playVideo() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPlaying) {
        timer.cancel();
      }
      if (_currentImage != null) {
        getPrediction(_currentImage!);
      }
    });

    if (_isPlaying) {
      controller.pause();
      setState(() => _isPlaying = false);
    } else {
      setState(() => _isPlaying = true);
      controller.play();
      // controller.addListener(() async {
      //   Uint8List image = await controller.takeSnapshot();
      //   setState(() {
      //     final temp = Image.memory(image);
      //     _currentImage = img.Image.fromBytes(
      //         temp.width!.toInt(), temp.height!.toInt(), image);
      //   });
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: ElevatedButton(
              onPressed: () {
                context.go("/navigator");
              },
              child: const Icon(Icons.arrow_back))),
      body: Column(
        children: [
          Expanded(
              child: VlcPlayer(
            aspectRatio: controller.value.aspectRatio,
            controller: controller,
            placeholder: const Center(child: CircularProgressIndicator()),
          )),
          Container(
            margin: const EdgeInsets.only(top: 15, bottom: 15),
            color: Theme.of(context).colorScheme.primary,
            child: const Text(
                textAlign: TextAlign.center,
                'This is the transcription of the sign language'),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FutureBuilder(
                  future: controller.getTime(),
                  builder: ((context, snapshot) {
                    return Text(
                        'Time: ${snapshot.data != null ? snapshot.data! / 1000 : 0}');
                  })),
              FloatingActionButton(
                  child: Icon(
                    !_isPlaying ? Icons.play_arrow : Icons.pause,
                    color: _isPlaying ? Colors.red : Colors.green,
                  ),
                  onPressed: () => _playVideo()),
            ],
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
