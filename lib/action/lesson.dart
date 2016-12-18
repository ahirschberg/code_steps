import 'dart:developer';
import 'package:code_steps/action/step.dart';

class Lesson {
  List<Step> steps;
  Lesson(this.steps);

  get length => steps.length;
  Step getStep(int index) => steps[index];

  static Lesson deserialize(Map data) {
    List<Step> steps = data['steps'].toList();

    // copy previous step's code if null
    for (int i = 1; i < steps.length; i++) {
      if (steps[i].code == null) steps[i].code = steps[i-1].code;
    }

    return new Lesson(steps);
  }
}