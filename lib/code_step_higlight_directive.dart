library attribute_directives.code_step_highlight;

import 'package:angular2/core.dart';
import 'dart:html';
import 'package:Polymorph/progression_service.dart';


// TODO figure out how to remove hack and have selector
// re-run when changes detected
@Directive(
    selector: 'c-frame[data-frame]'
)
class CodeStepHighlight {
  ProgressionService progressionService;

  CodeStepHighlight(ElementRef element,
      ProgressionService this.progressionService, {ElementRef root}) {
    print('got $element');
    if (element == null) {
      applyAll__hack(root);
    } else {
      _apply(element.nativeElement);
    }
  }

  /// hack for direct dom access because the directive selector only runs on
  /// initial startup
  void applyAll__hack(ElementRef root) {
    (root.nativeElement as Element)
        .querySelectorAll('c-frame[data-frame]')
        .forEach(_apply);
  }
  void _apply(Element element) {
    if (element.attributes['data-frame'] == progressionService.currStep.toString()) {
      element.classes.add('active-step');
    } else {
      element.classes.remove('active-step');
    }
  }
}