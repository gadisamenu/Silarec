import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:silarec/Presentation/Screens/Browse/browse.dart';
import 'package:silarec/Presentation/Screens/Live%20Recording/live_recording.dart';
import 'package:silarec/Presentation/Screens/Settings/settings.dart';
import 'package:silarec/Presentation/Screens/Videos/videos.dart';

class AppNavigator extends StatefulWidget {
  final storagePermission;
  AppNavigator({required this.storagePermission});

  @override
  State<AppNavigator> createState() =>
      _AppNavigator(storagePermission: storagePermission);
}

class _AppNavigator extends State<AppNavigator> {
  final PermissionStatus storagePermission;
  _AppNavigator({required this.storagePermission});
  static List? _bodys;

  @override
  void initState() {
    super.initState();
    _bodys = <Widget>[
      Videos(),
      Browse(storagePermission: storagePermission),
      LiveRecording(),
      Settings()
    ];
  }

  int _current_index = 0;

  void _onItemTapped(int index) {
    setState(() {
      _current_index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: Text(
          _bodys![_current_index].get_title() ?? "Silarec",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        elevation: 0,
        toolbarOpacity: 0.0,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _bodys![_current_index],
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Theme.of(context).iconTheme.color,
        // elevation: 500,
        currentIndex: _current_index,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.video_collection_outlined),
            label: "Videos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: "Browse",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: "Live Recording",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          )
        ],
      ),
    );
  }
}
