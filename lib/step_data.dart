import 'dart:collection';

class StepData {
  String index;
  HashMap<String, List<String>> cmds;
  String html;

  StepData(this.index, this.cmds, this.html);

  static List<StepData> toStepData(Iterable raw_steps) {
    return raw_steps.map((step) =>
        new StepData(step['index'], step['cmds'], step['html'])
    ).toList();
  }
}