import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:silarec/Application/Start/start_bloc.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final startBloc = BlocProvider.of<StartBloc>(context);
    return BlocConsumer<StartBloc, StartState>(
      listenWhen: (previous, current) => (current is! Loading),
      listener: (context, state) async {
        if (state is Introduction) {
          context.go("/introduction1");
        } else if (state is Loaded) {
          context.go("/navigator");
        } else {
          startBloc.add(LoadModel());
        }
      },
      buildWhen: (previous, current) => current is Loading,
      builder: (context, state) {
        startBloc.add(LoadModel());
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
