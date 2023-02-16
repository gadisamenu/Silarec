import 'package:silarec/Services/ai_model.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import '../constants/models.dart';

class SignLanguageDetector extends AiModel {
  SignLanguageDetector({this.interpreter}) {
    loadModel();
  }

  final double exist_threshold = 0.1;
  final double score_threshold = 0.3;

  @override
  Interpreter? interpreter;

  @override
  int get getAddress => interpreter!.address;

  @override
  Future<void> loadModel() async {
    try {
      final interpreterOptions = InterpreterOptions();

      interpreter ??= await Interpreter.fromAsset(ModelFile.hands,
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

  List<double>? runSilarec(TensorImage input) {
    if (interpreter == null) {
      print('Interpreter not initialized');
      return null;
    }

    TensorBuffer outputWords = TensorBufferFloat(outputShapes[0]);
    TensorBuffer outputExist = TensorBufferFloat(outputShapes[1]);
    TensorBuffer outputScores = TensorBufferFloat(outputShapes[2]);

    final inputs = <Object>[input.buffer];

    final outputs = <int, Object>{
      0: outputWords.buffer,
      1: outputExist.buffer,
      2: outputScores.buffer,
    };

    interpreter!.run(inputs, outputs);

    if (outputExist.getDoubleValue(0) < exist_threshold ||
        outputScores.getDoubleValue(0) < score_threshold) {
      return null;
    }

    return outputWords.getDoubleList();
  }
}
