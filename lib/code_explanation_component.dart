import 'package:angular2/core.dart';
import 'package:angular2/src/facade/async.dart';
import 'progression_service.dart';
import 'package:observe/observe.dart';

@Component(
    selector: 'code-explanation',
    template: '',
    styleUrls: const ['code_explanation_component.css']
)
class CodeExplanationComponent implements OnInit {

  @Input('changeListener') EventEmitter emitter;
  @Input('my_test') String test;

  final ElementRef _elementRef;
  final ProgressionService progressionService;

  CodeExplanationComponent(this._elementRef, this.progressionService);

  ngOnInit() {
    progressionService.changes.listen((List<ChangeRecord> a) {
      _elementRef.nativeElement.innerHtml
          = progressionService.currStepExplanationHtml;
    });
  }
}
