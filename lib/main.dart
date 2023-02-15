// import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silarec/Application/Start/start_bloc.dart';
import 'package:silarec/Application/Theme/theme_bloc.dart';
import 'Presentation/_shared/theme.dart';
import 'Presentation/_shared/router.dart';

void main() {
  runApp(const SilarecApp());
}

class SilarecApp extends StatelessWidget {
  const SilarecApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => ThemeBloc(),
        ),
        BlocProvider(
          create: (BuildContext context) => StartBloc(),
        )
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) => MaterialApp.router(
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
          title: "Silarec",
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: state.theme_mode,
        ),
      ),
    );
  }
}

// import 'package:camera/camera.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// void main() => runApp(MaterialApp(home: _MyHomePage()));

// class _MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<_MyHomePage> {
//   dynamic _scanResults;
//   CameraController? _camera;

//   bool _isDetecting = false;
//   CameraLensDirection _direction = CameraLensDirection.back;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }

//   Future<CameraDescription> _getCamera(CameraLensDirection dir) async {
//     return await availableCameras().then(
//       (List<CameraDescription> cameras) => cameras.firstWhere(
//         (CameraDescription camera) => camera.lensDirection == dir,
//       ),
//     );
//   }

//   void _initializeCamera() async {
//     _camera = CameraController(
//       await _getCamera(_direction),
//       defaultTargetPlatform == TargetPlatform.iOS
//           ? ResolutionPreset.low
//           : ResolutionPreset.medium,
//     );
//     await _camera!.initialize();
//     _camera!.startImageStream((CameraImage image) {
//       if (_isDetecting) return;
//       _isDetecting = true;
//       try {
//         return SizedBox(
//           child: Image.memory(image);
//         )
//         // await doSomethingWith(image)
//       } catch (e) {
//         // await handleExepction(e)
//       } finally {
//         _isDetecting = false;
//       }
//     });
//   }

//   Widget build(BuildContext context) {
//     return Text("Null");
//   }
// }
