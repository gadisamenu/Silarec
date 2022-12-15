import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:silarec/Application/Start/start_bloc.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final start_bloc = BlocProvider.of<StartBloc>(context)..add(LoadModel());
    return BlocConsumer<StartBloc, StartState>(
      listenWhen: (previous, current) => current is Loaded,
      listener: (context, state) {
        context.go("/videos");
      },
      buildWhen: (previous, current) => current is Loading,
      builder: (context, state) {
        return Container(
          height: double.infinity,
          width: double.infinity,
          color: Theme.of(context).colorScheme.primary,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/App-logo.png"),
              const SizedBox(
                height: 20,
              ),
              Text(
                "SLAREC",
                style: Theme.of(context).textTheme.headlineLarge,
              )
            ],
          ),
        );
      },
    );
  }
}
