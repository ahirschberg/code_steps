import 'package:angular2/core.dart';
import 'package:code_steps/step_actions_provider.dart';
import 'package:observe/observe.dart';
import 'dart:collection';
import 'lesson_loader.dart';
import 'package:code_steps/step_data.dart';
import 'dart:async';

@Injectable()
class ProgressionService extends Injectable with ChangeNotifier {

  LessonLoader _lessonLoader;
  StepActionsProvider _stepActionsProvider;
  ProgressionService(LessonLoader this._lessonLoader, this._stepActionsProvider);

  Future selectLesson(url) {
    return _lessonLoader.loadData(url).then((HashMap lessonData) {
      loadedSteps = StepData.toStepData(_stepActionsProvider, lessonData['steps']);
      loadedCode = lessonData['code'];
      _currStep = notifyPropertyChange(#currStep, _currStep, 0);
    });
  }

  int _currStep = 0;

  List<StepData> _loadedSteps;
  @reflectable List<StepData> get loadedSteps => _loadedSteps;
  @reflectable set loadedSteps(List<StepData> val) =>
    _loadedSteps = notifyPropertyChange(#loadedSteps, _loadedSteps, val);

  String _loadedCode;
  @reflectable String get loadedCode => _loadedCode;
  @reflectable set loadedCode(String val) =>
      _loadedCode = notifyPropertyChange(#loadedCode, _loadedCode, val);

  void gotoNextStep() {
    _currStep = notifyPropertyChange(#nextStep, _currStep, _currStep + 1);
  }

  bool hasNext() => _loadedSteps != null && _currStep < _loadedSteps.length - 1;

  void gotoPreviousStep() {
    _currStep = notifyPropertyChange(#previousStep, _currStep, _currStep - 1);
  }

  bool hasPreviousStep() => _loadedSteps != null && _currStep > 0;

  StepData get currStep => loadedSteps == null ? null :
      loadedSteps[_currStep];
  StepData get previousStep =>
      (loadedSteps == null || _currStep - 1 < 0)
          ? null
          : loadedSteps[_currStep - 1];

  StepData get nextStep =>
      (loadedSteps == null || _currStep >= _loadedSteps.length)
          ? null
          : loadedSteps[_currStep + 1];

  String get currCodeHtml => loadedCode;

  int get test => _currStep;
}