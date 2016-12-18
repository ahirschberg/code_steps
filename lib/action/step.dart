import 'package:code_steps/action/action_region.dart';

class Step {
  String explanation;
  String code;
  Set<ActionRegion> activeRegions;

  Step(this.explanation, this.code, this.activeRegions) {
    this.activeRegions ??= new Set<ActionRegion>();
  }


  Map toJson() => {'explanation': explanation, 'regions': activeRegions};

  static Step deserialize(Map data) {
    return new Step(data['explanation'], data['code'], null);
  }
}
