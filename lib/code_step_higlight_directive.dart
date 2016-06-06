library attribute_directives.code_step_highlight;

import 'package:angular2/core.dart';
import 'dart:html';


// TODO figure out how to remove hack and have selector
// re-run when changes detected
@Directive(
    selector: 'c-frame[data-frame]'//_selectorStr
)
class CodeStepHighlight {
  CodeStepHighlight(ElementRef element) {
    print('got $element');
    _apply(element.nativeElement);
  }

  /// hack for direct dom access because the directive selector only runs on
  /// initial startup
  static void applyAll__hack(ElementRef root) {
    (root.nativeElement as Element)
        .querySelectorAll('c-frame[data-frame]')
        .forEach(_apply);
  }
  static void _apply(Element element) {
    List<String> colors = ['yellow', 'blue', 'red', 'green'];
    colors.shuffle();
    element.style.backgroundColor = colors.first;
  }
}