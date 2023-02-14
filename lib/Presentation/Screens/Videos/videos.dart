import 'package:flutter/material.dart';
import 'package:silarec/Presentation/Screens/Videos/samplePlayer.dart';

class Videos extends StatelessWidget {
  const Videos({super.key});

  @override
  Widget build(BuildContext context) {
    
    return const SamplePlayer(url: 'assets/videos/file_example.webm');
  }

  String get_title() => "Video";
}

