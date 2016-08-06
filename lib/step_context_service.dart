import 'package:angular2/core.dart';
import 'package:code_steps/step_actions_provider.dart';
import 'package:observe/observe.dart';
import 'dart:collection';
import 'lesson_loader.dart';
import 'package:code_steps/step_data.dart';
import 'dart:async';

@Injectable()
class StepContextService extends Injectable with ChangeNotifier {
  LessonLoader _lessonLoader;
  StepActionsProvider _stepActionsProvider;
  StepContextService(
      LessonLoader this._lessonLoader, this._stepActionsProvider);

  Future selectLesson(url) {
    return _lessonLoader.loadData(url).then((HashMap lessonData) {
      loadedSteps =
          StepData.toStepData(_stepActionsProvider, lessonData['steps']);
      loadedCode = lessonData['code'];
      _stepIndex = notifyPropertyChange(#currStep, _stepIndex, 0);
    });
  }

  int _stepIndex = 0;

  List<StepData> _loadedSteps;
  @reflectable
  List<StepData> get loadedSteps => _loadedSteps;
  @reflectable
  set loadedSteps(List<StepData> val) =>
      _loadedSteps = notifyPropertyChange(#loadedSteps, _loadedSteps, val);

  String _loadedCode;
  @reflectable
  String get loadedCode => _loadedCode;
  @reflectable
  set loadedCode(String val) =>
      _loadedCode = notifyPropertyChange(#loadedCode, _loadedCode, val);

  void gotoNext() {
    _stepIndex = notifyPropertyChange(#nextStep, _stepIndex, _stepIndex + 1);
  }

  bool hasNext() =>
      _loadedSteps != null && _stepIndex < _loadedSteps.length - 1;

  void gotoPrevious() {
    _stepIndex =
        notifyPropertyChange(#previousStep, _stepIndex, _stepIndex - 1);
  }

  bool hasPrevious() => _loadedSteps != null && _stepIndex > 0;

  StepData get currStep => loadedSteps == null ? null : loadedSteps[_stepIndex];

  int get stepIndex => _stepIndex;

  /**
   * Sets the step index to a desired value. If a string is passed in, it is converted to an integer automatically
   */
  set stepIndex(new_currStep) {
    if (new_currStep is String) new_currStep = int.parse(new_currStep);
    _stepIndex = notifyPropertyChange(
        new_currStep < _stepIndex ? #previousStep : #nextStep,
        _stepIndex,
        new_currStep);
  }

  /**
   * Returns the number of steps, or zero if no steps are loaded
   */
  int get length => loadedSteps?.length ?? 0;

  StepData get previousStep => (loadedSteps == null || _stepIndex - 1 < 0)
      ? null
      : loadedSteps[_stepIndex - 1];

  StepData get nextStep => (loadedSteps == null ||
      _stepIndex >= _loadedSteps.length) ? null : loadedSteps[_stepIndex + 1];

  String get currCodeHtml => loadedCode;
}
