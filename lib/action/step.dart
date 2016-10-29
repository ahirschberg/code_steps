import 'package:code_steps/action/action_region.dart';

class Step {
  String explanation;
  Set<ActionRegion> _activeRegions;

  Step(this.explanation, this._activeRegions) {
    this._activeRegions ??= new Set<ActionRegion>();
  }

  Set<ActionRegion> get activeRegions => this._activeRegions;

  Map toJson() => {'explanation': explanation, 'action_region': activeRegions};

  static Step fromJson(Map json) {
    return new Step(json['explanation'], json['action_region']);
  }
}
