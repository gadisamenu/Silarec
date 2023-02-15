import 'dart:io';
import 'package:image/image.dart' as image_lib;
import 'package:silarec/Services/ai_model.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import '../constants/models.dart';

class PoseDetector extends AiModel{
  PoseDetector({this.interpreter}) {
    loadModel();
  }

  final double exist_threshold = 0.1;
  final double score_threshold = 0.3;

  @override
  Interpreter? interpreter;

  @override
  int get getAddress => interpreter!.address;

  Future<void> loadModel() async {
    try {
      final interpreterOptions = InterpreterOptions();

      interpreter ??= await Interpreter.fromAsset(ModelFile.pose,
          options: interpreterOptions);

      final outputTensors = interpreter!.getOutputTensors();

      outputTensors.forEach((tensor) {
        outputShapes.add(tensor.shape);
        outputTypes.add(tensor.type);
      });
    } catch (e) {
      print('Error while creating interpreter: $e');
    }
  }

  List<double>? runPoseDetector(image_lib.Image image) {
    if (interpreter == null) {
      print('Interpreter not initialized');
      return null;
    }

    if (Platform.isAndroid) {
      image = image_lib.copyRotate(image, -90);
      image = image_lib.flipHorizontal(image);
    }
    final tensorImage = TensorImage(TfLiteType.float32);
    tensorImage.loadImage(image);

    TensorBuffer outputLandmarks = TensorBufferFloat(outputShapes[0]);
    TensorBuffer outputExist = TensorBufferFloat(outputShapes[1]);
    TensorBuffer outputScores = TensorBufferFloat(outputShapes[2]);

    final inputs = <Object>[tensorImage.buffer];

    final outputs = <int, Object>{
      0: outputLandmarks.buffer,
      1: outputExist.buffer,
      2: outputScores.buffer,
    };

    interpreter!.runForMultipleInputs(inputs, outputs);

    if (outputExist.getDoubleValue(0) < exist_threshold ||
        outputScores.getDoubleValue(0) < score_threshold) {
      return null;
    }

    return outputLandmarks.getDoubleList();
  }
}

