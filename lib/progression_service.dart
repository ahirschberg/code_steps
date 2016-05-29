import 'package:angular2/core.dart';
import 'dart:collection';
import 'dart:html';
import 'package:observe/observe.dart';


@Injectable()
class ProgressionService extends Injectable with ChangeNotifier {

  String _currHtml;
  @reflectable get currHtml => _currHtml;
  @reflectable set currHtml(String val) =>
    _currHtml = notifyPropertyChange(#currHtml, _currHtml, val);

  getFrameHTML(HashMap hash, int i) {
    currHtml = "<section>Appended dynamically ${hash['frames'][i]['text']}</section>";
  }
}