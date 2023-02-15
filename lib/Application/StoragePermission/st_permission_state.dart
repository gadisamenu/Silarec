part of 'st_permission_bloc.dart';

abstract class StPermissionState {}

class Granted extends StPermissionState {}

class Deined extends StPermissionState {}

class PermanentlyDenied extends StPermissionState {}
