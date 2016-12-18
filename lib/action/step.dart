import 'package:code_steps/action/action_region.dart';

class Step {
  String explanation;
  Set<ActionRegion> _activeRegions;

  Step(this.explanation, this._activeRegions) {
    this._activeRegions ??= new Set<ActionRegion>();
  }

  Set<ActionRegion> get activeRegions => this._activeRegions;

  Map toJson() => {'explanation': explanation, 'regions': activeRegions};

  static Step fromJson(Map json) {
    // FIXME
    return new Step(json['explanation'], null);
  }
}
