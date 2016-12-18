import 'package:code_steps/action/step.dart';

class Lesson {
  List<Step> steps;
  String code;
  Lesson(this.steps, this.code);

  get length => steps.length;
  Step getStep(int index) => steps[index];

  static Lesson deserialize(Map data) {
    return new Lesson(data['steps'].toList(), data['code']);
  }
}