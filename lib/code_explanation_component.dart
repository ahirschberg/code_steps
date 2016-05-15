import 'package:angular2/core.dart';

@Component(
    selector: 'code-explanation',
    template: '<div>TEST {{my_test}}</div>'
)
class CodeExplanationComponent implements OnInit {

  @Input('my_test') String my_test;
  ElementRef e;
  Renderer r;

  CodeExplanationComponent(ElementRef this.e, Renderer this.r);

  ngOnInit() {
    print('init??');
    print("e is $e");
    print("r is $r");
//    e.nativeElement
  }
}
