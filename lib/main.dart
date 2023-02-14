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