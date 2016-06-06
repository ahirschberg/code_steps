import 'package:angular2/core.dart';
import 'package:observe/observe.dart';
import 'dart:async';
import 'dart:html';
import 'dart:collection';
import 'dart:convert';

@Injectable()
class ProgressionService extends Injectable with ChangeNotifier {

  int _currStep = 1;
  get currStep => _currStep;

  HashMap _currData;
  @reflectable get currData => _currData;
  @reflectable set currData(HashMap val) =>
    _currData = notifyPropertyChange(#currData, _currData, val);

  Future<HashMap> _loadData(url) {
    return HttpRequest.getString(url).then((String value) {
      return JSON.decode(value);
    }).catchError((Object o) => print(o));
  }

  void loadStepthroughData(url) {
    _loadData(url).then((data) => currData = data);
  }

  void nextStep() {
    _currStep = notifyPropertyChange(#currStep, _currStep, _currStep + 1);
  }

  bool hasNext() => currData != null && _currStep < _currData['steps'].length;

  get currStepExplanationHtml =>
      _currData['steps'][_currStep - 1]['html'].toString();
  get codeHtml => _currData['code'];
}