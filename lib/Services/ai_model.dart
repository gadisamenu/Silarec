import 'package:equatable/equatable.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

// ignore: must_be_immutable
abstract class AiModel extends Equatable {

  AiModel({this.interpreter});

  final outputShapes = <List<int>>[];
  final outputTypes = <TfLiteType>[];

  double exist_threshold = 0.1;
  double score_threshold = 0.3;

  Interpreter? interpreter;

  @override
  List<Object> get props => [];

  int get getAddress;

  Future<void> loadModel();
}
