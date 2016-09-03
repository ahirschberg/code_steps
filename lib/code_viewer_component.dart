import 'dart:developer';
import 'package:angular2/core.dart';
import 'package:code_steps/action_region.dart';
import 'package:code_steps/lesson_serializer.dart';
import 'package:code_steps/step_action.dart';
import 'package:code_steps/step_context_service.dart';
import 'package:ace/ace.dart' as ace;
import 'package:observe/observe.dart';
import 'package:code_steps/highlightjs_interop.dart' as highlighter;
import 'dart:html';
import 'package:code_steps/util.dart';

@Component(
    selector: 'code-viewer',
    template: '',
    styleUrls: const ['css/code_viewer_component.css'])
class CodeViewerComponent implements OnInit {
  final NodeValidatorBuilder _codeViewerValidator = new NodeValidatorBuilder()
    ..allowElement('pre')
    ..allowElement('cs-region', attributes: const ["f-id"]);

  final StepContextService stepContextService;
  ElementRef _elementRef;

  CodeViewerComponent(this.stepContextService, this._elementRef);

  ngOnInit() {

    Util.filterChangeStreamByProp(stepContextService.changes, [
      #changeStep
    ]).listen((PropertyChangeRecord change) => _addCodeHtml(_addHtmlRegions(
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
    List<String> rows = code.split('\n');
    regions.forEach((ActionRegion region) {
      Set<StepActionType> actions = region.stepData[step];
      ace.Point start = region.range.start;
      ace.Point end = region.range.end;
      if(actions != null) {
        rows[start.row] = _strInsertAt(
            rows[start.row],
            start.column,
            '<cs-region class="action-'
                '${actions.map((t) => 'lesson-' + LessonSerializer.stepActionTypeHelper.
            stringFromEnum(t).toLowerCase()).join(' ')}');
        rows[end.row] = _strInsertAt(rows[end.row], end.column, '</cs-region>');
      }
    });
    return rows.join('\n');
  }
}
