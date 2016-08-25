import 'package:code_steps/lesson_serializer.dart';
import 'package:code_steps/step_action.dart';
import 'package:ace/ace.dart' as ace;

class ActionRegion {
  ace.Marker marker;
  String uniqClass;
  Map<int, Set<StepActionType>> stepData = {};

  ActionRegion(this.marker, this.uniqClass);

  String toString() => "ActionEditRegion($marker, $stepData)";

  Map toJson() {
    var obj = {
      'range': marker.range,
      'step_data': LessonSerializer.transformMap(stepData,
          value: (Set<StepActionType> set) =>
              set.map(LessonSerializer.stepActionTypeTransformer).toList())
    };
    print(obj);
    return obj;
  }

  Map<StepActionType, bool> getActionStates(int step) {
    return new Map.fromIterable(
      StepActionType.values, value: (state) => stepData[step]?.contains(state) == true);
  }
}
