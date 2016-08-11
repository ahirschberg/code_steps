import 'package:angular2/core.dart' show Component, OnInit;

import 'package:code_steps/code_explanation_component.dart';
import 'package:code_steps/code_viewer_component.dart';
import 'package:angular2/router.dart';
import 'package:code_steps/step_action.dart';
import 'package:code_steps/step_context_service.dart';

@Component(
    selector: 'code-guide',
    templateUrl: 'html/code_guide_component.html',
    styleUrls: const ['css/code_guide_component.css'],
    directives: const [CodeExplanationComponent, CodeViewerComponent])
class CodeGuideComponent implements OnInit {
  StepContextService stepContextService;
  RouteParams _routeParams;
  CodeGuideComponent(this.stepContextService, this._routeParams);

  ngOnInit() {
    String lesson_name = _routeParams.get('lesson_name');
    stepContextService
        .selectLesson(
            'static/lesson-$lesson_name.json', _routeParams.get('step'))
        .catchError((dynamic err) => print('ERROR: $err'));
  }
}
