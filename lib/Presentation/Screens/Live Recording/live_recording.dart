import 'package:flutter/material.dart';
import 'package:silarec/Presentation/_shared/Widgets/buttom_navigator_bar.dart';

class LiveRecording extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      bottomNavigationBar: navBar,
      body: Text("Record"),
    );
  }
}
