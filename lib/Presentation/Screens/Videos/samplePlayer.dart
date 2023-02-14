// ignore: file_names
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class SamplePlayer extends StatefulWidget {
  final String url;
  const SamplePlayer({Key? key, required this.url}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SamplePlayerState createState() => _SamplePlayerState();
}

class _SamplePlayerState extends State<SamplePlayer> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  @override
  void initState() {
    videoPlayerController = VideoPlayerController.asset(widget.url);
    videoPlayerController.initialize().then((value) => null);
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Testing')),
        body: Container(
          height: 400,
          child: Chewie(
            controller: ChewieController(
              videoPlayerController: videoPlayerController,
              autoInitialize: true,
              autoPlay: true,
              looping: true,
              aspectRatio: videoPlayerController.value.aspectRatio,
              // placeholder: ,
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
    );
  }
}
