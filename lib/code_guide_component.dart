import 'package:angular2/core.dart' show Component, ComponentRef, Directive, DynamicComponentLoader, ElementRef, EventEmitter, OnInit, ViewChild, ViewContainerRef;

import 'code_explanation_component.dart';
import 'progression_service.dart';
import 'dart:async';
import 'code_viewer_component.dart';

@Component(
  selector: 'code-guide',
  templateUrl: 'code_guide_component.html',
  styleUrls: const ['code_guide_component.css'],
  directives: const [CodeExplanationComponent, CodeViewerComponent]
)
class CodeGuideComponent implements OnInit {

  final ProgressionService _progressionService;

  CodeGuideComponent(this._progressionService);

  void ngOnInit() {
    _progressionService.loadStepthroughData('/static/lesson-polymorphism.json');
//    new Timer(new Duration(seconds: 5), () => _progressionService.loadStepthroughData('/static/404'));
  }

}

