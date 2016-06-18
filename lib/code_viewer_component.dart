import 'package:angular2/core.dart';
import 'package:Polymorph/progression_service.dart';
import 'package:observe/observe.dart';
import 'package:Polymorph/highlightjs_interop.dart' as highlighter;
import 'dart:html';
import 'code_step_higlight_directive.dart';

@Component(
    selector: 'code-viewer',
    template: '',
    styleUrls: const ['code_viewer_component.css'],
    directives: const [CodeStepHighlight]
)
class CodeViewerComponent implements OnInit {

  final NodeValidatorBuilder _codeViewerValidator = new NodeValidatorBuilder()
    ..allowElement('pre')
    ..allowElement('c-frm', attributes: const ["class", "f-step"]);

  final ProgressionService progressionService;
  ElementRef _elementRef;

  CodeViewerComponent(this.progressionService, this._elementRef);

  ngOnInit() {
    filterChangeStreamByProp(progressionService.changes, [#currData])
        .listen((PropertyChangeRecord change) {
          Element e = new Element.html(
              "<pre>${progressionService.codeHtml}</pre>",
              validator: _codeViewerValidator);

          _elementRef.nativeElement.append(e);
          highlighter.highlightBlock(e);
          return false;
        });

    filterChangeStreamByProp(progressionService.changes, [#currStep, #currData])
        .listen((PropertyChangeRecord change) {
          new CodeStepHighlight(null, progressionService, root: _elementRef); // TODO remove hack!
        });
  }

  Stream filterChangeStreamByProp(Stream propStream, List<Symbol> propNames) =>
    propStream
        .map((List<ChangeRecord> changes) =>
          changes.lastWhere((ChangeRecord c) =>
            c.runtimeType == PropertyChangeRecord
              && propNames.contains((c as PropertyChangeRecord).name),
            orElse: () => null)
        ).where((test) => test != null);
}