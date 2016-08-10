import 'dart:developer';
import 'package:angular2/core.dart';
import 'package:code_steps/step_context_service.dart';
import 'package:code_steps/step_data.dart';
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
    ..allowElement('c-frm', attributes: const ["f-id"])
    ..allowElement('c-line', attributes: const ["f-id"]);

  final StepContextService stepContextService;
  ElementRef _elementRef;
  StepData _lastStep;

  CodeViewerComponent(this.stepContextService, this._elementRef);

  ngOnInit() {
    Util.filterChangeStreamByProp(stepContextService.changes,
        [#loadedCode]).listen((PropertyChangeRecord change) {
      // why is nativeElement dynamic :{
      Element root = _elementRef.nativeElement as Element;

      root.setInnerHtml("<pre>${stepContextService.currCodeHtml}</pre>",
          validator: _codeViewerValidator);
      try {
        highlighter.highlightBlock(root.firstChild);
      } catch (exception) {
        print("WARN: Failed to highlight the code viewer.\n$exception");
      }
    });

    Util.filterChangeStreamByProp(stepContextService.changes, [
      #changeStep, #loadedCode
    ]).listen((PropertyChangeRecord change) {
      _lastStep?.destroy(_elementRef);
      stepContextService
          .currStep.applyAllActions(_elementRef);
      _lastStep = stepContextService.currStep;
    });
  }
}
