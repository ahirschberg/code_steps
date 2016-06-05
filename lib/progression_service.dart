import 'package:angular2/core.dart';
import 'package:observe/observe.dart';
import 'dart:async';
import 'dart:html';
import 'dart:collection';
import 'dart:convert';

@Injectable()
class ProgressionService extends Injectable with ChangeNotifier {

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

  String getExplanationText(int frameIndex) =>
      _currData['steps'][frameIndex]['html'].toString();

  String getCodeText() =>
      _currData['code'];
}