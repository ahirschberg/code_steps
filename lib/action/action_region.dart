library action_region;
import 'package:code_steps/editor/lesson_code_editor_component.dart';
import 'package:code_steps/lesson_serializer.dart';
import 'package:code_steps/action/step_action.dart';
import 'package:ace/ace.dart';

class ActionRegion {
  Set<StepActionType> actions;
  Range range;

  ActionRegion(this.range, [this.actions]) {
    if (this.actions == null) this.actions = new Set<StepActionType>();
  }

  String toString() => "ActionRegion($range, $actions)";

  Map toJson() {
    var obj = {
      'range': range,
      'actions': actions.map((type) =>
          LessonSerializer.stepActionTypeHelper.stringFromEnum(type)).toList()
    };
    return obj;
  }

  Map<StepActionType, bool> getActionStates() {
    return new Map.fromIterable(StepActionType.values,
        value: (state) => actions?.contains(state) == true);
  }
}
