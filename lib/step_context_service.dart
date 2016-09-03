import 'package:angular2/core.dart';
import 'package:code_steps/action_region.dart';
import 'package:code_steps/lesson_serializer.dart';
import 'package:code_steps/step_actions_provider.dart';
import 'package:observe/observe.dart';
import 'dart:collection';
import 'package:code_steps/lesson_loader.dart';
import 'dart:async';

@Injectable()
class StepContextService extends Injectable with ChangeNotifier {
  LessonLoader _lessonLoader;
  StepActionsProvider _stepActionsProvider;
  StepContextService(
      LessonLoader this._lessonLoader, this._stepActionsProvider);

  Future selectLesson(url, [initial_step_index]) {
    return _lessonLoader.loadData(url).then((HashMap lessonData) {
      loadedSteps = lessonData['expl'];
      loadedCode = lessonData['code'];
      loadedRegions = lessonData['regions'];
      print('regions: $loadedRegions');
      print('code: $loadedCode');
      stepIndex = initial_step_index ?? 0;
    }).catchError((e) => print(e));
  }

  int _stepIndex = -1;
  List<String> loadedSteps;
  String loadedCode;
  List<ActionRegion> loadedRegions;


  void gotoNext() {
    _stepIndex = notifyPropertyChange(#changeStep, _stepIndex, _stepIndex + 1);
  }

  bool hasNext() =>
      loadedSteps != null && _stepIndex < loadedSteps.length - 1;

  void gotoPrevious() {
    _stepIndex = notifyPropertyChange(#changeStep, _stepIndex, _stepIndex - 1);
  }

  bool hasPrevious() => loadedSteps != null && _stepIndex > 0;
  int get stepIndex => _stepIndex;

  /**
   * Sets the step index to a desired value. If a string is passed in, it is converted to an integer automatically
   */
  set stepIndex(new_stepIndex) {
    if (new_stepIndex is String) new_stepIndex = int.parse(new_stepIndex);
    if (new_stepIndex >= 0 && new_stepIndex < length) {
      _stepIndex = notifyPropertyChange(#changeStep, _stepIndex, new_stepIndex);
    } else {
      print('ERROR: Index $new_stepIndex out of bounds.');
    }
  }

  /**
   * Returns the number of steps, or zero if no steps are loaded
   */
  int get length => loadedSteps?.length ?? 0;

  String get currCodeHtml => loadedCode;
  String get currStepHtml => loadedSteps[stepIndex];
}
