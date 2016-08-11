import 'package:angular2/core.dart';
import 'package:code_steps/step_actions_provider.dart';
import 'package:code_steps/step_action.dart';

class StepData {
  String index;
  List<StepAction> actions;
  String html;

  StepData(this.index, this.actions, this.html);

  void applyAllActions(ElementRef root) =>
      actions.forEach((StepAction a) => a.apply(root));
  void destroy(ElementRef root) =>
      actions.forEach((StepAction a) => a.destroy(root));

  static List<StepData> toStepData(
      StepActionsProvider stepActionsProvider, Iterable raw_steps) {
    return raw_steps
        .map((step) => new StepData(step['index'],
            _generateActions(stepActionsProvider, step['cmds']), step['html']))
        .toList();
  }

  static List<StepAction> _generateActions(
      StepActionsProvider stepActionsProvider, Map cmds) {
    return cmds.keys.map((String action_name) {
      dynamic action_targets = cmds[action_name];
      if (!(action_targets is List<String>)) {
        throw new Exception("Action targets must be of type List<String>,"
            " got ${action_targets.runtimeType}");
      }
      return new StepAction(stepActionsProvider.getActionModel(action_name),
          action_targets.toSet());
    }).toList();
  }

  static void interpolateSteps(
      StepActionsProvider stepActionsProvider, List<StepData> steps) {
    Map<StepActionType, StepAction> toggles =
        new Map<StepActionType, StepAction>();
    steps.forEach((StepData step) {
      step.actions = step.actions.map((StepAction action) {
        if (action.model is ToggleActionModel) {
          toggles
              .putIfAbsent(action.model.type, () => action)
              .targets
              .addAll(action.targets); // merge like toggles
          StepActionType opposite =
              (action.model as ToggleActionModel).opposite;
          if (toggles.containsKey(opposite)) {
            toggles[opposite].targets.removeAll(action.targets);
          }
          return null; // remove the toggled action from the list, for now
        } else {
          return action;
        }
      }).where((e) => e != null).toList(); // todo make this more elegant!
      step.actions.addAll(toggles.values.map((action) => action.copy()));
    });
  }
}
