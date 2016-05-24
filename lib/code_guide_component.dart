import 'package:angular2/core.dart' show Component, ComponentRef, Directive, DynamicComponentLoader, ElementRef, EventEmitter, OnInit, ViewChild, ViewContainerRef;
import 'dart:html' show Element, HttpRequest, NodeValidatorBuilder, querySelector, window;
import 'dart:convert';
import 'dart:collection';

import 'code_explanation_component.dart' show CodeExplanationComponent;
import 'dart:async';

@Component(
  selector: 'code-guide',
  templateUrl: 'code_guide_component.html',
  directives: const [CodeExplanationComponent]
)
class CodeGuideComponent implements OnInit {
  final NodeValidatorBuilder _htmlValidator = new NodeValidatorBuilder.common()
    ..allowElement('section', attributes: const ["my_test"]);

  var frameData;
  final EventEmitter frameDataEmitter = new EventEmitter();

  void ngOnInit() {
    var request = HttpRequest.getString('/static/guide_ex.json').then((String value) {
      HashMap obj = JSON.decode(value);
      print(obj);
      frameData = getFrameHTML(obj, 0);
      new Timer(new Duration(seconds: 30), () {print('frame2!'); frameData = getFrameHTML(obj, 1);});
    }).catchError((Object o) => print(o));

    print(request);
  }

  getFrameHTML(HashMap hash, int i) {
    var html_str = "<section my_test=\"test_attr\">Appended dynamically ${hash['frames'][i]['text']}</section>";
    Element e = new Element.html(html_str, validator: _htmlValidator);
    frameDataEmitter.emit(e);
    return e;
  }
}

