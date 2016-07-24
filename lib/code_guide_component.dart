import 'package:angular2/core.dart' show Component;

import 'code_explanation_component.dart';
import 'code_viewer_component.dart';
import 'package:code_steps/step_cmds_directive.dart';

@Component(
  selector: 'code-guide',
  templateUrl: 'html/code_guide_component.html',
  styleUrls: const ['css/code_guide_component.css'],
  directives: const [CodeExplanationComponent, CodeViewerComponent, StepCommandsDirective]
)
class CodeGuideComponent {}