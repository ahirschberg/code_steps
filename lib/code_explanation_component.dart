import 'package:angular2/core.dart';
import 'package:angular2/src/facade/async.dart';
import 'progression_service.dart';
import 'dart:collection';

@Component(
    selector: 'code-explanation',
    template: '<div>TEST</div>'
)
class CodeExplanationComponent implements OnInit {

  @Input('changeListener') EventEmitter emitter;
  @Input('my_test') String test;

  final ElementRef _elementRef;
  final ProgressionService progressionService;

  CodeExplanationComponent(this._elementRef, this.progressionService);

  ngOnInit() {
    print('init??');
    progressionService.changes.listen((UnmodifiableListView a) {
      print("GOT MESSAGE FROM EMITTER! $a");
      _elementRef.nativeElement.innerHtml = a.first.newValue;
    });
  }
}
