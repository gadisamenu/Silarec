// import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silarec/Application/Start/start_bloc.dart';
import 'package:silarec/Application/StoragePermission/st_permission_bloc.dart';
import 'package:silarec/Application/Theme/theme_bloc.dart';
import 'Presentation/_shared/theme.dart';
import 'Presentation/_shared/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final PermissionStatus storagePermission = await Permission.storage.status;
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  runApp(
    MyApp(
      sharedPreferences: sharedPreferences,
      stPermission: storagePermission,
    ),
  );
}

class MyApp extends StatelessWidget {
  final PermissionStatus stPermission;
  final SharedPreferences sharedPreferences;
  const MyApp({
    required this.sharedPreferences,
    required this.stPermission,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => ThemeBloc(),
        ),
        BlocProvider(
          create: (BuildContext context) =>
              StartBloc(sdPreferences: sharedPreferences),
        ),
        BlocProvider(
          create: (BuildContext context) =>
              StPermissionBloc(stPermission: stPermission),
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
