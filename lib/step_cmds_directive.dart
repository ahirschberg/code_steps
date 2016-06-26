import 'package:angular2/core.dart';
import 'package:Polymorph/progression_service.dart';
import 'dart:collection';
import 'package:Polymorph/util.dart';
import 'package:observe/observe.dart';
import 'dart:html';

@Directive(
    selector: 'code-viewer'
)
class StepCommandsDirective implements OnInit {
  Map<String, Function> commandActions = {
    'fail': 'test'
  };
  ElementRef root;
  ProgressionService progressionService;
  Map<Element, List<String>> lastModified = new HashMap<Element, List<String>>();

  StepCommandsDirective(this.root, this.progressionService) {
    commandActions['fail'] = (List<String> targets,
                              Map<Element, List<String>> changes) =>
        selectMatching(targets, 'hl-fail', changes);

    commandActions['pass'] = (List<String> targets,
                              Map<Element, List<String>> changes) =>
        selectMatching(targets, 'hl-pass', changes);

    commandActions['show'] = (List<String> targets,
        Map<Element, List<String>> changes) =>
        selectMatching(targets, 'hl-show', changes, persistent: true);

    commandActions['hide'] = (List<String> targets,
        Map<Element, List<String>> changes) =>
        selectMatching(targets, 'hl-hide', changes, persistent: true);
  }

  selectMatching(List<String> f_ids, class_to_apply,
                 Map<Element, List<String>> changes, {persistent: false}) {
    f_ids.forEach((String target) {
      dynamic matches = root.nativeElement.querySelectorAll('[f-id="$target"]');
      matches.forEach((Element e) {
        if (!persistent) {
          changes.putIfAbsent(e, () => new List<String>());
          changes[e].add(class_to_apply);
        } else {
          if (class_to_apply == 'hl-hide' || class_to_apply == 'hl-show') {
            e.classes.removeAll(['hl-hide', 'hl-show']);
          }
        }
        e.classes.add(class_to_apply);
      });
    });
  }


  void applyStepCommands(HashMap<String, List<String>> cmds) {
    Map<Element, List<String>> modified = new HashMap<Element, List<String>>();
    lastModified.forEach((element, classes) => element.classes.removeAll(classes));
    cmds.forEach((action, targets) {
      if (commandActions.containsKey(action)) {
        commandActions[action](targets, modified);
      } else {
        throw new Exception('No such action "$action"');
      }
    });
    lastModified = modified;
  }

  ngOnInit() {
    Util.filterChangeStreamByProp(progressionService.changes, [#currStep, #loadedCode]).listen(
        (PropertyChangeRecord change) => applyStepCommands(progressionService.currStep.cmds)
    );
  }
}
