import 'package:code_steps/lesson_serializer.dart';
import 'package:code_steps/step_action.dart';
import 'package:ace/ace.dart' as ace;

class ActionRegion {
  ace.Range _range;
  Map<int, Set<StepActionType>> stepData;

  ActionRegion(this._range, [this.stepData]) {
    if (this.stepData == null) this.stepData = {};
  }

  ace.Range get range => _range;
  String toString() => "ActionRegion($range, $stepData)";

  Map toJson() {
    var obj = {
      'range': range,
      'step_data': LessonSerializer.transformMap(stepData,
          value: (Set<StepActionType> set) =>
              set.map(LessonSerializer.stepActionTypeTransformer).toList())
    };
    print(obj);
    return obj;
  }

  Map<StepActionType, bool> getActionStates(int step) {
    return new Map.fromIterable(StepActionType.values,
        value: (state) => stepData[step]?.contains(state) == true);
  }
}

class EditorActionRegion extends ActionRegion {
  ace.Marker marker;
  String uniqClass;
  EditorActionRegion(ace.Marker m, this.uniqClass) : super(m.range) {
    this.marker = m;
  }

  Map toJson() => super.toJson();
}