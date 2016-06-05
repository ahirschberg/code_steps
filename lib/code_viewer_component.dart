import 'package:angular2/core.dart';
import 'package:Polymorph/progression_service.dart';
import 'package:observe/observe.dart';

@Component(
    selector: 'code-viewer',
    template: '<pre>{{code}}</pre>'
)
class CodeViewerComponent implements OnInit {

  ProgressionService progressionService;
  ElementRef _elementRef;
  String code; // temp!

  CodeViewerComponent(this.progressionService, this._elementRef);

  ngOnInit() {
    progressionService.changes.listen((List<ChangeRecord> a) {
      print(progressionService.getCodeText());
      code = progressionService.getCodeText();
    });
  }
}