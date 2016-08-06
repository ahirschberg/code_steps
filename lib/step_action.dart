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


