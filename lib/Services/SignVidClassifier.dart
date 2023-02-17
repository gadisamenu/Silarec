import 'package:silarec/Services/constants/models.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import 'Classifier.dart';

class SignVidClassifier extends Classifier {
  SignVidClassifier({int numThreads = 1}) : super(numThreads: numThreads);

  @override
  String get modelName => ModelFile.singleFrame;

  @override
  NormalizeOp get preProcessNormalizeOp => NormalizeOp(0, 255);

  @override
  NormalizeOp get postProcessNormalizeOp => NormalizeOp(0, 1);
}
