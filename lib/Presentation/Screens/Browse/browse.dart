import 'package:flutter/material.dart';

class Browse extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ListView(
          children: [
            Align(
              child: Icon(Icons.search_rounded, size: 30),
              alignment: Alignment.centerRight,
            ),
            ListTile(
              title: Text("Storages"),
              subtitle: Row(
                children: [
                  Icon(Icons.smartphone),
                  Icon(Icons.sd_card),
                ],
              ),
            ),
            ListTile(
              title: Text("Recent Folders"),
              subtitle: Row(
                children: [
                  Icon(Icons.folder),
                  Icon(Icons.folder),
                ],
              ),
            ),
            ListTile(
              title: Text("Recent Videos"),
            )
          ],
        ),
      ),
    );
  }

  String get_title() => "Browse";
}
