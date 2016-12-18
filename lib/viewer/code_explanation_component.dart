import 'package:angular2/core.dart';
import 'package:code_steps/step_context_service.dart';
import 'dart:html';
import 'package:markdown/markdown.dart' show markdownToHtml;

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
    stepContextService.onStepChange.listen((_) {
      String html = markdownToHtml(stepContextService.currentStep.explanation);
      _elementRef.nativeElement.setInnerHtml(html,
          validator: _explanationViewerValidator);
    });
  }
}

class _AllUriPolicy implements UriPolicy {
  bool allowsUri(String uri) => true;
}
