import 'package:angular2/core.dart';
import 'package:Polymorph/progression_service.dart';
import 'package:observe/observe.dart';
import 'package:Polymorph/highlightjs_interop.dart' as highlighter;
import 'dart:html';

@Component(
    selector: 'code-viewer',
    template: '',
    styles: const ['''
      :host { padding: 0; }
      :host pre { margin: 0; }
    ''']
)
class CodeViewerComponent implements OnInit {

  final NodeValidatorBuilder _codeViewerValidator = new NodeValidatorBuilder()
    ..allowElement('pre')
    ..allowElement('c-frame', attributes: const ["data-frame"]);

  ProgressionService progressionService;
  ElementRef _elementRef;

  CodeViewerComponent(this.progressionService, this._elementRef);

  ngOnInit() {
    progressionService.changes.listen((List<ChangeRecord> a) {
      print(progressionService.getCodeText());
      Element e = new Element.html("<pre>${progressionService.getCodeText()}</pre>", validator: _codeViewerValidator);
      _elementRef.nativeElement.append(e);
      highlighter.highlightBlock(e);
    });
  }
}