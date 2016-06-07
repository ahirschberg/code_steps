import 'package:angular2/core.dart';
import 'package:observe/observe.dart';
import 'dart:collection';
import 'lesson_loader.dart';

@Injectable()
class ProgressionService extends Injectable with ChangeNotifier {

  LessonLoader _lessonLoader;
  ProgressionService(LessonLoader this._lessonLoader);

  void selectLesson(url) {
    _lessonLoader.loadData(url)
        .then((HashMap lessonData) => currData = lessonData);
  }

  int _currStep = 1;
  int get currStep => _currStep;

  HashMap _currData;
  @reflectable get currData => _currData;
  @reflectable set currData(HashMap val) =>
    _currData = notifyPropertyChange(#currData, _currData, val);

  void nextStep() {
    _currStep = notifyPropertyChange(#currStep, _currStep, _currStep + 1);
  }

  bool hasNext() => currData != null && _currStep < _currData['steps'].length;

  get currStepExplanationHtml =>
      _currData['steps'][_currStep - 1]['html'].toString();
  get codeHtml => _currData['code'];
}