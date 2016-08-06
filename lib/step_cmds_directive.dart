import 'package:angular2/core.dart';
import 'dart:html';

class StepActionModel {
  Function _apply, _destroy_to_previous, _destroy_to_next;
  StepActionModel(
      this._apply, this._destroy_to_previous, this._destroy_to_next);

  void apply(ElementRef root, String target) => _apply(root, target);
  void destroyToPrevious(ElementRef root, String target) =>
      _destroy_to_previous(root, target);
  void destroyToNext(ElementRef root, String target) =>
      _destroy_to_next(root, target);
}

class NonDirectionalActionModel extends StepActionModel {
  NonDirectionalActionModel(Function apply, Function destroy)
      : super(apply, destroy, destroy);
  NonDirectionalActionModel.fromPair(
      List<Function> pair) // named constructor, neat!
      : this(pair[0], pair[1]);
}

class ToggleActionModel extends StepActionModel {
  ToggleActionModel(Function apply, Function destroy_to_previous)
      : super(apply, destroy_to_previous, (_1, _2) {});
  ToggleActionModel.fromPair(List<Function> pair) : this(pair[0], pair[1]);
}

class StepAction {
  StepActionModel _sam;
  List<String> _targets;

  StepAction(this._sam, this._targets);

  void apply(ElementRef root) =>
      _targets.forEach((String t) => _sam.apply(root, t));
  void destroyToPrevious(ElementRef root) =>
      _targets.forEach((String t) => _sam.destroyToPrevious(root, t));
  void destroyToNext(ElementRef root) =>
      _targets.forEach((String t) => _sam.destroyToNext(root, t));
}

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
      'show': new ToggleActionModel.fromPair(easyPairAddClass('hl-hide').reversed.toList()),
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
      applyToRegion((Element e) {print('adding $html_class'); e.classes.add(html_class);}),
      applyToRegion((Element e) {print('removing $html_class'); e.classes.remove(html_class);})
    ];
  }
}
