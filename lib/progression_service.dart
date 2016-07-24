import 'package:angular2/core.dart';
import 'package:observe/observe.dart';
import 'dart:collection';
import 'lesson_loader.dart';
import 'package:code_steps/step_data.dart';
import 'dart:async';

@Injectable()
class ProgressionService extends Injectable with ChangeNotifier {

  LessonLoader _lessonLoader;
  ProgressionService(LessonLoader this._lessonLoader);

  Future selectLesson(url) {
    return _lessonLoader.loadData(url).then((HashMap lessonData) {
      loadedSteps = StepData.toStepData(lessonData['steps']);
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

  void nextStep() {
    _currStep = notifyPropertyChange(#currStep, _currStep, _currStep + 1);
  }

  bool hasNext() => _loadedSteps != null && _currStep < _loadedSteps.length - 1;

  void prevStep() {
    _currStep = notifyPropertyChange(#currStep, _currStep, _currStep - 1);
  }

  bool hasPrev() => _loadedSteps != null && _currStep > 0;

  StepData get currStep => loadedSteps == null ? null :
      loadedSteps[_currStep];
  String get currCodeHtml => loadedCode;
}