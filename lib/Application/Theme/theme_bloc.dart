// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:silarec/Presentation/_shared/theme.dart';
part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(theme_mode: ThemeMode.system)) {
    on<SystemMode>(_system_mode);
    on<DarkMode>(_dark_mode);
    on<LightMode>(_light_mode);
  }

  void _system_mode(ThemeEvent SystemMode, Emitter emit) {
    emit(ThemeState(theme_mode: ThemeMode.system));
  }

  void _dark_mode(ThemeEvent SystemMode, Emitter emit) {
    emit(ThemeState(theme_mode: ThemeMode.dark));
  }

  void _light_mode(ThemeEvent SystemMode, Emitter emit) {
    emit(ThemeState(theme_mode: ThemeMode.light));
  }
}
