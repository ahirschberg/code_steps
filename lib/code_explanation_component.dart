import 'package:angular2/core.dart';
import 'package:angular2/src/facade/async.dart';

@Component(
    selector: 'code-explanation',
    template: '<div>TEST</div>'
)
class CodeExplanationComponent implements OnInit {

  @Input('changeListener') EventEmitter emitter;
  @Input('my_test') String test;

  ngOnInit() {
    print('init??');
    ObservableWrapper.subscribe(emitter, (var a) {
      print("GOT MESSAGE FROM EMITTER! $a");

    });
  }
}
