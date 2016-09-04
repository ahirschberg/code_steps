import 'package:angular2/core.dart';
import 'package:code_steps/action_region.dart';
import 'package:code_steps/lesson_serializer.dart';
import 'package:code_steps/step_action.dart';
import 'package:code_steps/step_context_service.dart';
import 'package:ace/ace.dart' as ace;
import 'package:observe/observe.dart';
import 'package:code_steps/highlightjs_interop.dart' as highlighter;
import 'dart:html';

@Component(
    selector: 'code-viewer',
    template: '',
    styleUrls: const ['css/code_viewer_component.css'])
class CodeViewerComponent implements OnInit {
  final NodeValidatorBuilder _codeViewerValidator = new NodeValidatorBuilder()
    ..allowElement('pre')
    ..allowElement('cs-region', attributes: const ["class"]);

  final StepContextService stepContextService;
  ElementRef _elementRef;

  CodeViewerComponent(this.stepContextService, this._elementRef);

  ngOnInit() {

    stepContextService.onStepChange.listen((PropertyChangeRecord change) => _addCodeHtml(_addHtmlRegions(
        stepContextService.currCodeHtml,
        stepContextService.loadedRegions,
        stepContextService.stepIndex)));
  }

  _addCodeHtml(String codeHtml) {
    // why is nativeElement dynamic :(
    Element root = _elementRef.nativeElement as Element;

    root.setInnerHtml("<pre>${codeHtml}</pre>",
        validator: _codeViewerValidator);
    try {
      highlighter.highlightBlock(root.firstChild);
    } catch (exception) {
      print("WARN: Failed to highlight the code viewer.\n$exception");
    }
  }

  String _strInsertAt(String s, int col, String toInsert) =>
      "${s.substring(0, col)}$toInsert${s.substring(col + 1)}";

  String _addHtmlRegions(String code, List<ActionRegion> regions, int step) {
    List<LineInsert> rows = code.split('\n').map((row) => new LineInsert(row)).toList(growable: false);
    regions.forEach((ActionRegion region) {
      Set<StepActionType> actions = region.stepData[step];
      ace.Point start = region.range.start;
      ace.Point end = region.range.end;
      if(actions != null) {
        String openTag = '<cs-region class="'
                '${actions.map((t) => 'action-' + LessonSerializer.stepActionTypeHelper.
            stringFromEnum(t).toLowerCase()).join(' ')}">';
        rows[start.row].insert(openTag, start.column);
        rows[end.row].insert('</cs-region>', end.column);
      }
    });
    return rows.join('\n');
  }
}

class StringInsert {
  String value;
  StringInsert(this.value);
  String toString() => value;
}

class LineInsert {
  List<String> parts;
  LineInsert(String row) : this.parts = [row];

  void insert(String toInsert, int col) {
    int length = 0;
    parts = parts.expand((var s) {
      if (!(s is StringInsert)) {
        if (length + s.length >= col) {
          return [
            s.substring(0, col - length),
            new StringInsert(toInsert),
            s.substring(col - length)
          ];
        }
          length += s.length;
      }

      return [s];
    }).toList();
  }

  String toString() => parts.join(); // flatten and join
}