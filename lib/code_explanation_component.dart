import 'package:angular2/core.dart';
import 'package:code_steps/step_context_service.dart';
import 'package:observe/observe.dart';
import 'dart:html';

@Component(
    selector: 'code-explanation',
    template: '',
    styleUrls: const ['css/code_explanation_component.css']
)
class CodeExplanationComponent implements OnInit {


  final NodeValidatorBuilder _explanationViewerValidator = new NodeValidatorBuilder.common()
    ..allowImages(new _AllUriPolicy());

  final ElementRef _elementRef;
  final StepContextService stepContextService;

  CodeExplanationComponent(this._elementRef, this.stepContextService);

  ngOnInit() {
    stepContextService.changes.listen((List<ChangeRecord> a) {
      _elementRef.nativeElement.setInnerHtml(stepContextService.currStep.html,
          validator: _explanationViewerValidator);
    });
  }
}

class _AllUriPolicy implements UriPolicy {
  bool allowsUri(String uri) => true;
}
