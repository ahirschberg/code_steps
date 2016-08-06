import 'dart:html';
import 'package:angular2/core.dart';
import 'package:code_steps/step_action.dart';

@Injectable()
class StepActionsProvider extends Injectable {
  final Map<String, NonDirectionalActionModel> commandActions = {};

  StepActionsProvider() {
    commandActions.addAll({
      'fail':
      new NonDirectionalActionModel.fromPair(easyPairAddClass('hl-fail')),
      'pass':
      new NonDirectionalActionModel.fromPair(easyPairAddClass('hl-pass')),
      'spotlight': new NonDirectionalActionModel.fromPair(
          easyPairAddClass('hl-spotlight')),
      'hide': new ToggleActionModel.fromPair(easyPairAddClass('hl-hide')),
      'show': new ToggleActionModel.fromPair(
          easyPairAddClass('hl-hide').reversed.toList()),
      'spotlight-line': new NonDirectionalActionModel.fromPair(
          easyPairAddClass('active')) // little bit hack-ey here...
    });
  }

  Function applyToRegion(Function action) {
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
  List<Function> easyPairAddClass(String html_class) {
    return [
      applyToRegion((Element e) {
        print('adding $html_class');
        e.classes.add(html_class);
      }),
      applyToRegion((Element e) {
        print('removing $html_class');
        e.classes.remove(html_class);
      })
    ];
  }
}
