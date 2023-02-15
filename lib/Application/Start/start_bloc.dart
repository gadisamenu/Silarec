import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'start_event.dart';

part 'start_state.dart';

class StartBloc extends Bloc<StartEvent, StartState> {
  final SharedPreferences sdPreferences;
  StartBloc({required this.sdPreferences})
      : super(sdPreferences.getBool("first_time") ?? true
            ? Introduction()
            : Loading()) {
    on<LoadModel>(_start_app);
  }

  // ignore: non_constant_identifier_names
  void _start_app(StartEvent event, Emitter emit) async {
    await Future.delayed(const Duration(seconds: 2));
    emit(Loaded());
  }
}
