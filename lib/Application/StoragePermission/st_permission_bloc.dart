import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
part 'st_permission_event.dart';

part 'st_permission_state.dart';

class StPermissionBloc extends Bloc<StPermissionEvent, StPermissionState> {
  final PermissionStatus stPermission;

  StPermissionBloc({required this.stPermission})
      : super(stPermission.isGranted ? Granted() : Deined()) {
    on<GetPermission>(_get_permission);
    on<OpenSetting>(_open_setting);
    on<OpenFile>(_open_file);
  }

  // ignore: non_constant_identifier_names
  void _get_permission(StPermissionEvent event, Emitter emit) async {
    emit(Deined);
  }

  void _open_file(StPermissionEvent event, Emitter emit) {
    if (stPermission.isGranted) {
      emit(Granted);
    } else {
      emit(Deined);
    }
  }

  void _open_setting(StPermissionEvent event, Emitter emit) async {
    if (stPermission.isPermanentlyDenied) {
      emit(PermanentlyDenied);
      return;
    }
    emit(OpenSetting);
  }
}
