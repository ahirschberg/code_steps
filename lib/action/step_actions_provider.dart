import 'dart:html';
import 'package:angular2/core.dart';
import 'package:code_steps/action/step_action.dart';

@Injectable()
class StepActionsProvider extends Injectable {
  Map<StepActionType, StepActionModel> _commandActions;

  StepActionsProvider() {
    _commandActions = { // TODO: CLEAN THIS UP x_x
      StepActionType.Pass: new NonDirectionalActionModel.fromPair(
          StepActionType.Pass, _easyPairAddClass('hl-pass')),
      StepActionType.Fail: new NonDirectionalActionModel.fromPair(
          StepActionType.Fail, _easyPairAddClass('hl-fail')),
      StepActionType.Spotlight: new NonDirectionalActionModel.fromPair(
          StepActionType.Spotlight, _easyPairAddClass('hl-spotlight')),
      StepActionType.Show: new ToggleActionModel.fromPair(StepActionType.Show,
          _easyPairAddClass('hl-hide').reversed.toList(), StepActionType.Hide),
      StepActionType.Hide: new ToggleActionModel.fromPair(StepActionType.Hide,
          _easyPairAddClass('hl-hide'), StepActionType.Show),
      StepActionType.LineSpotlight: new NonDirectionalActionModel.fromPair(
          StepActionType.LineSpotlight,
          _easyPairAddClass('active')) // little bit hack-ey here...
    };
  }

  StepActionModel modelFromType(StepActionType t) => _commandActions[t];

  StepActionModel getActionModel(String action_name) {
    const transformer = const {
      'pass': StepActionType.Pass,
      'fail': StepActionType.Fail,
      'spotlight': StepActionType.Spotlight,
      'show': StepActionType.Show,
      'hide': StepActionType.Hide,
      'spotlight-line': StepActionType.LineSpotlight
    };
    return _commandActions[transformer[action_name]];
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
