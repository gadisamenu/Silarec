part of 'st_permission_bloc.dart';

abstract class StPermissionEvent {}

class GetPermission extends StPermissionEvent {}

class OpenSetting extends StPermissionEvent {}

class OpenFile extends StPermissionEvent {}
