import 'package:angular2/core.dart';
import 'package:angular2/src/facade/async.dart';
import 'progression_service.dart';
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
  final ProgressionService progressionService;

  CodeExplanationComponent(this._elementRef, this.progressionService);

  ngOnInit() {
    progressionService.changes.listen((List<ChangeRecord> a) {
      _elementRef.nativeElement.setInnerHtml(progressionService.currStep.html,
          validator: _explanationViewerValidator);
    });
  }
}

class _AllUriPolicy implements UriPolicy {
  bool allowsUri(String uri) => true;
}
