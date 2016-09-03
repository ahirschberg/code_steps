import 'package:angular2/core.dart';
import 'package:code_steps/action_region.dart';
import 'package:observe/observe.dart';
import 'dart:collection';
import 'package:code_steps/lesson_loader.dart';
import 'dart:async';

@Injectable()
class StepContextService extends Injectable {
  LessonLoader _lessonLoader;
  StepContextService(LessonLoader this._lessonLoader);
  StreamController<PropertyChangeRecord<int>> _stepChangeController =
      new StreamController<PropertyChangeRecord<int>>.broadcast();
  Stream<PropertyChangeRecord<int>> get onStepChange =>
      _stepChangeController.stream;

  Future selectLesson(lesson_name, [initial_step_index]) {
    return _lessonLoader.smartLoadData(lesson_name).then((HashMap lessonData) {
      loadedSteps = lessonData['expl'];
      loadedCode = lessonData['code'];
      loadedRegions = lessonData['regions'];
      stepIndex = initial_step_index ?? 0;
    }).catchError((e) => print(e));
  }

  int _stepIndex = 0;
  List<String> loadedSteps;
  String loadedCode;
  List<ActionRegion> loadedRegions;

  dynamic _onChangeStepIndex(newValue) {
    _stepChangeController
        .add(new PropertyChangeRecord(this, #stepIndex, _stepIndex, newValue));
    return newValue;
  }

  void gotoNext() {
    stepIndex = _stepIndex + 1;
  }

  bool hasNext() => loadedSteps != null && _stepIndex < loadedSteps.length - 1;

  void gotoPrevious() {
    stepIndex = _stepIndex - 1;
  }

  bool hasPrevious() => loadedSteps != null && _stepIndex > 0;
  int get stepIndex => _stepIndex;

  /**
   * Sets the step index to a desired value. If a string is passed in, it is converted to an integer automatically
   */
  set stepIndex(new_stepIndex) {
    if (new_stepIndex is String) new_stepIndex = int.parse(new_stepIndex);
    if (new_stepIndex < 0 || new_stepIndex > length) {
      print('WARN: Index $new_stepIndex out of bounds.');
    }
    _stepIndex = _onChangeStepIndex(new_stepIndex);
  }

  /**
   * Returns the number of steps, or zero if no steps are loaded
   */
  int get length => loadedSteps?.length ?? 0;

  String get currCodeHtml => loadedCode;
  String get currStepHtml => loadedSteps[stepIndex];
}
