import 'dart:html';
import 'package:angular2/core.dart';
import 'package:code_steps/step_action.dart';

@Injectable()
class StepActionsProvider extends Injectable {
  final Map<String, NonDirectionalActionModel> commandActions = {};

  StepActionsProvider() {
    commandActions.addAll({
      'fail':
      new NonDirectionalActionModel.fromPair(_easyPairAddClass('hl-fail')),
      'pass':
      new NonDirectionalActionModel.fromPair(_easyPairAddClass('hl-pass')),
      'spotlight': new NonDirectionalActionModel.fromPair(
          _easyPairAddClass('hl-spotlight')),
      'hide': new ToggleActionModel.fromPair(_easyPairAddClass('hl-hide')),
      'show': new ToggleActionModel.fromPair(
          _easyPairAddClass('hl-hide').reversed.toList()),
      'spotlight-line': new NonDirectionalActionModel.fromPair(
          _easyPairAddClass('active')) // little bit hack-ey here...
    });
  }

  Function _applyToRegion(Function action) {
    return (ElementRef root, String target) {
      dynamic matches = root.nativeElement.querySelectorAll('[f-id="$target"]');
      matches.forEach((Element e) => action(e));
    };
  }

  /**
   * Provides a shortcut for generating functions to add and remove html
   * classes from targeted regions.
   *
   * Returns a [List] of length 2 with the pattern [apply(), destroy()].
   */
  List<Function> _easyPairAddClass(String html_class) {
    return [
      _applyToRegion((Element e) => e.classes.add(html_class)),
      _applyToRegion((Element e) => e.classes.remove(html_class))
    ];
  }
}
