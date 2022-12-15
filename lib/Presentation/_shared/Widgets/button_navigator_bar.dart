// import 'package:flutter/cupertino.dart';
import 'dart:collection';

import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppBottomNavigator extends StatefulWidget {
  @override
  State<AppBottomNavigator> createState() => _AppBottomNavigatorState();
}

class _AppBottomNavigatorState extends State<AppBottomNavigator> {
  List paths = <String>["/videos", "/browse", "/liverecording", "/settings"];
  static int _current_index = 0;

  void _onItemTapped(int index) {
    setState(() {
      _current_index = index;
      context.go(paths[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(current_index);
    // print("__________________________");
    return BottomNavigationBar(
        showUnselectedLabels: true,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Theme.of(context).iconTheme.color,
        elevation: 500,
        currentIndex: _current_index,
        // elevation: 0,
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
        type: BottomNavigationBarType.fixed);
  }
}

// class SingletonTest {
//   SingletonTest._();
//   static Widget navBar = AppBottomNavigator();

//   static final instance = SingletonTest._();
// }

final navBar = AppBottomNavigator();
