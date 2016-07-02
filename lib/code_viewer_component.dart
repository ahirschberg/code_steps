import 'package:angular2/core.dart';
import 'package:Polymorph/progression_service.dart';
import 'package:observe/observe.dart';
import 'package:Polymorph/highlightjs_interop.dart' as highlighter;
import 'dart:html';
import 'package:Polymorph/util.dart';

@Component(
    selector: 'code-viewer',
    template: '',
    styleUrls: const ['css/code_viewer_component.css']
)
class CodeViewerComponent implements OnInit {

  final NodeValidatorBuilder _codeViewerValidator = new NodeValidatorBuilder()
    ..allowElement('pre')
    ..allowElement('c-frm', attributes: const ["f-id"])
    ..allowElement('c-hl', attributes: const ["f-ln-num"]);

  final ProgressionService progressionService;
  ElementRef _elementRef;

  CodeViewerComponent(this.progressionService, this._elementRef);

  ngOnInit() {
    Util.filterChangeStreamByProp(progressionService.changes, [#loadedCode])
        .listen((PropertyChangeRecord change) {
          // why is nativeElement dynamic :{
          Element root = _elementRef.nativeElement as Element;

          root.setInnerHtml("<pre>${progressionService.currCodeHtml}</pre>",
              validator: _codeViewerValidator);
          highlighter.highlightBlock(root.firstChild);
        });
  }


}