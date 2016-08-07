import 'package:angular2/core.dart';

enum StepActionType {
  Pass, Fail, Spotlight, Hide, Show, LineSpotlight
}
abstract class StepActionModel {
  Function _apply, _destroy_to_previous, _destroy_to_next;
  final StepActionType type;
  StepActionModel(this.type,
      this._apply, this._destroy_to_previous, this._destroy_to_next);

  void apply(ElementRef root, String target) {
    print('applying $type to $target');
    _apply(root, target);
  }
  void destroyToPrevious(ElementRef root, String target) =>
      _destroy_to_previous(root, target);
  void destroyToNext(ElementRef root, String target) =>
      _destroy_to_next(root, target);

  @override
  String toString() => "<${this.runtimeType}: $type>";
}

class NonDirectionalActionModel extends StepActionModel {
  NonDirectionalActionModel(StepActionType type, Function apply, Function destroy)
      : super(type, apply, destroy, destroy);
  NonDirectionalActionModel.fromPair(StepActionType type,
      List<Function> pair) // typed constructor, neat!
      : this(type, pair[0], pair[1]);
}

class ToggleActionModel extends StepActionModel {
  final StepActionType opposite;
  ToggleActionModel(StepActionType type,
      Function apply, Function destroy_to_previous, this.opposite)
      : super(type, apply, destroy_to_previous, (_1, _2) {});
  ToggleActionModel.fromPair(StepActionType type, List<Function> pair, StepActionType opposite)
      : this(type, pair[0], pair[1], opposite);
}

class StepAction {
  StepActionModel model;
  Set<String> targets;

  StepAction(this.model, this.targets);

  void apply(ElementRef root) =>
      targets.forEach((String t) => model.apply(root, t));
  void destroyToPrevious(ElementRef root) =>
      targets.forEach((String t) => model.destroyToPrevious(root, t));
  void destroyToNext(ElementRef root) =>
      targets.forEach((String t) => model.destroyToNext(root, t));

  @override
  String toString() => "Action($model, $targets)";

  copy() => new StepAction(model, targets.toSet());
}
