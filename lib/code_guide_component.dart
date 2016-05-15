import 'package:angular2/core.dart' show Component, ComponentRef, Directive, DynamicComponentLoader, ElementRef, OnInit, ViewChild, ViewContainerRef;
import 'dart:html' show Element, HttpRequest, NodeValidatorBuilder, querySelector;
import 'dart:convert';
import 'dart:collection';

import 'code_explanation_component.dart' show CodeExplanationComponent;

@Component(
  selector: 'code-guide',
  templateUrl: 'code_guide_component.html',
  directives: const [CodeExplanationComponent]
)
class CodeGuideComponent implements OnInit {
  final NodeValidatorBuilder _htmlValidator = new NodeValidatorBuilder.common()
    ..allowElement('section', attributes: const ["my_test"]);

  final DynamicComponentLoader _loader;
  final ViewContainerRef _vc;

  CodeGuideComponent(DynamicComponentLoader this._loader, ViewContainerRef this._vc);

  void ngOnInit() {
    var request = HttpRequest.getString('/static/guide_ex.json').then((String value) {
      HashMap obj = JSON.decode(value);
      print(obj);
      this._loader.loadNextToLocation(CodeExplanationComponent, this._vc)
        .then((ComponentRef cr) {
          CodeExplanationComponent c = cr.injector.get(CodeExplanationComponent);
          c.my_test = "ATTRIBUTE?";
          var html_str = "<section my_test=\"test_attr\">Appended dynamically ${obj['frames'][0]['text']}</section>";
          Element base = new Element.html(html_str, validator: _htmlValidator);
          c.e.nativeElement.append(base);
          c.e.nativeElement.append();
        });
    }).catchError((Object o) => print(o));

    print(request);
  }
}

