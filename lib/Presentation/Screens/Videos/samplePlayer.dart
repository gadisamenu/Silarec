// ignore: file_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:ui' as ui;

import 'package:screenshot/screenshot.dart';

class SamplePlayer extends StatefulWidget {
  final String url;
  const SamplePlayer({Key? key, required this.url}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SamplePlayerState createState() => _SamplePlayerState();
}

class _SamplePlayerState extends State<SamplePlayer> {
  late VideoPlayerController videoPlayerController;
  final ScreenshotController screenshotController = ScreenshotController();
  final GlobalKey widgetKey = GlobalKey();

  Uint8List? _imageFile;

  @override
  void initState() {
    videoPlayerController = VideoPlayerController.asset(widget.url);
    videoPlayerController.initialize().then((value) => value);

    // Timer.periodic(const Duration(seconds: 2), (_) {
    //   _captureImage();
    //   print('widgetshot taken...');
    // });

    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  Future<void> _captureImage() async {
    final RenderRepaintBoundary boundary =
        widgetKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;

    final ui.Image image = await boundary.toImage();
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();
    print(pngBytes.length);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 300,
          child: RepaintBoundary(
            key: widgetKey,
            // controller: screenshotController,
            child: Chewie(
              controller: ChewieController(
                videoPlayerController: videoPlayerController,
                autoInitialize: true,
                autoPlay: true,
                looping: true,
                aspectRatio: videoPlayerController.value.aspectRatio,
                placeholder: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary),
                deviceOrientationsOnEnterFullScreen: [
                  DeviceOrientation.landscapeRight,
                  DeviceOrientation.landscapeRight,
                  DeviceOrientation.portraitUp
                ],
                deviceOrientationsAfterFullScreen: [
                  DeviceOrientation.portraitUp
                ],
                subtitle: Subtitles([
                  Subtitle(
                    index: 0,
                    start: Duration.zero,
                    end: const Duration(seconds: 10),
                    text: 'Hello from subtitles',
                  ),
                  Subtitle(
                    index: 1,
                    start: const Duration(seconds: 10),
                    end: const Duration(seconds: 20),
                    text: 'Whats up? :)',
                  ),
                ]),
                subtitleBuilder: (context, subtitle) => Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
        ElevatedButton(
            child: const Text(
              'Capture',
            ),
            onPressed: () {
              _captureImage();
            }),
        _imageFile != null
            ? SizedBox(height: 200, child: Image.memory(_imageFile!))
            : const Text('null')
      ],
    );
  }
}
