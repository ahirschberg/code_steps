import 'package:angular2/core.dart' show Component, OnInit;

import 'code_explanation_component.dart';
import 'progression_service.dart';
import 'code_viewer_component.dart';
import 'package:Polymorph/step_cmds_directive.dart';

@Component(
  selector: 'code-guide',
  templateUrl: 'html/code_guide_component.html',
  styleUrls: const ['css/code_guide_component.css'],
  directives: const [CodeExplanationComponent, CodeViewerComponent, StepCommandsDirective]
)
class CodeGuideComponent implements OnInit {

  final ProgressionService _progressionService;

  CodeGuideComponent(this._progressionService);

  void ngOnInit() {
    _progressionService.selectLesson('/static/lesson-polymorphism.json');
  }
}