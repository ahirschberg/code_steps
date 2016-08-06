import 'package:angular2/core.dart';
import 'step_actions_provider.dart';
import 'step_action.dart';

class StepData {
  String index;
  List<StepAction> actions;
  String html;

  StepData(this.index, this.actions, this.html);

  void applyAllActions(ElementRef root) =>
      actions.forEach((StepAction a) => a.apply(root));
  void destroyActionsToPrev(ElementRef root) =>
      actions.forEach((StepAction a) => a.destroyToPrevious(root));
  void destroyActionsToNext(ElementRef root) =>
      actions.forEach((StepAction a) => a.destroyToNext(root));

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
      return new StepAction(
          stepActionsProvider.commandActions[action_name], action_targets);
    }).toList();
  }
}
