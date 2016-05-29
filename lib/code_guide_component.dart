import 'package:angular2/core.dart' show Component, ComponentRef, Directive, DynamicComponentLoader, ElementRef, EventEmitter, OnInit, ViewChild, ViewContainerRef;
import 'dart:html' show Element, HttpRequest, NodeValidatorBuilder, querySelector, window;
import 'dart:convert';
import 'dart:collection';

import 'code_explanation_component.dart';
import 'dart:async';
import 'progression_service.dart';

@Component(
  selector: 'code-guide',
  templateUrl: 'code_guide_component.html',
  directives: const [CodeExplanationComponent]
)
class CodeGuideComponent implements OnInit {

  final ProgressionService _progressionService;

  CodeGuideComponent(this._progressionService);

  void ngOnInit() {
    var request = HttpRequest.getString('/static/guide_ex.json').then((String value) {
      HashMap obj = JSON.decode(value);
      _progressionService.getFrameHTML(obj, 0);
      new Timer(new Duration(seconds: 5), () => _progressionService.getFrameHTML(obj, 1));
    }).catchError((Object o) => print(o));
  }

}

