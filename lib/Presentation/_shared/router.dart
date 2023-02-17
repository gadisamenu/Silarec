import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silarec/Presentation/Screens/Videos/samplePlayer.dart';
import 'package:silarec/Presentation/Screens/splash_screen.dart';
import '../Screens/Introduction_screens/introduction_screen_1.dart';
import '../Screens/Introduction_screens/introduction_screen_2.dart';
import '../Screens/app_navigator.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: "/",
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) => SplashScreen(),
      ),
      GoRoute(
          path: "/navigator",
          builder: (BuildContext context, GoRouterState state) =>
              AppNavigator()),
      GoRoute(
        path: "/introduction1",
        builder: (BuildContext context, GoRouterState state) =>
            const Introduction1(),
      ),
      GoRoute(
        path: "/introduction2",
        builder: (BuildContext context, GoRouterState state) =>
            const Introduction2(),
      ),
      GoRoute(
        path: "/video_player",
        builder: (BuildContext context, GoRouterState state) =>
            ExampleVideo(file: state.extra as File, url: ""),
      )
    ],
  );
}
