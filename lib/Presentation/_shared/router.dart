import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silarec/Presentation/Screens/Browse/browse.dart';
import 'package:silarec/Presentation/Screens/Live%20Recording/live_recording.dart';
import 'package:silarec/Presentation/Screens/Settings/settings.dart';
import 'package:silarec/Presentation/Screens/Videos/videos.dart';
import 'package:silarec/Presentation/Screens/splash_screen.dart';
import '../Screens/introduction_screen_1.dart';
import '../Screens/introduction_screen_2.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: "/introduction1",
    routes: <GoRoute>[
      GoRoute(
        path: '/settings',
        builder: (BuildContext context, GoRouterState state) => Settings(),
      ),
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) => SplashScreen(),
      ),
      GoRoute(
        path: "/videos",
        builder: (BuildContext context, GoRouterState state) => Videos(),
      ),
      GoRoute(
        path: "/browse",
        builder: (BuildContext context, GoRouterState state) => Browse(),
      ),
      GoRoute(
        path: "/liverecording",
        builder: (BuildContext context, GoRouterState state) => LiveRecording(),
      ),
      GoRoute(
        path: "/introduction1",
        builder: (BuildContext context, GoRouterState state) => Introduction1(),
      ),
      GoRoute(
        path: "/introduction2",
        builder: (BuildContext context, GoRouterState state) => Introduction2(),
      )
    ],
  );
}
