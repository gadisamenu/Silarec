import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'start_event.dart';

part 'start_state.dart';

class StartBloc extends Bloc<StartEvent, StartState> {
  StartBloc() : super(Loading()) {
    on<LoadModel>(_start_app);
  }

  // ignore: non_constant_identifier_names
  void _start_app(StartEvent state, Emitter emit) async {
    emit(Loading());
    await Future.delayed(const Duration(seconds: 2));
    emit(Loaded());
  }
}
