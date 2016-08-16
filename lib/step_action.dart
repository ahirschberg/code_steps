import 'package:angular2/core.dart';
import 'package:dson/dson.dart';

@serializable
enum StepActionType { Pass, Fail, Spotlight, Hide, Show, LineSpotlight }

abstract class StepActionModel {
  Function _apply, _destroy;
  final StepActionType type;
  StepActionModel(this.type, this._apply, this._destroy);

  void apply(ElementRef root, String target) {
    _apply(root, target);
  }

  void destroy(ElementRef root, String target) => _destroy(root, target);

  @override
  String toString() => "<${this.runtimeType}: $type>";
}

class NonDirectionalActionModel extends StepActionModel {
  NonDirectionalActionModel(
      StepActionType type, Function apply, Function destroy)
      : super(type, apply, destroy);
  NonDirectionalActionModel.fromPair(
      StepActionType type, List<Function> pair) // typed constructor, neat!
      : this(type, pair[0], pair[1]);
}

class ToggleActionModel extends StepActionModel {
  final StepActionType opposite;
  ToggleActionModel(StepActionType type, Function apply,
      Function destroy_to_previous, this.opposite)
      : super(type, apply, destroy_to_previous);
  ToggleActionModel.fromPair(
      StepActionType type, List<Function> pair, StepActionType opposite)
      : this(type, pair[0], pair[1], opposite);
}

class StepAction {
  StepActionModel model;
  Set<String> targets;

  StepAction(this.model, this.targets);

  void apply(ElementRef root) =>
      targets.forEach((String t) => model.apply(root, t));
  void destroy(ElementRef root) =>
      targets.forEach((String t) => model.destroy(root, t));

  @override
  String toString() => "Action($model, $targets)";

  copy() => new StepAction(model, targets.toSet());
}
