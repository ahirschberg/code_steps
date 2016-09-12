import 'package:angular2/core.dart';
import 'package:code_steps/action/action_region.dart';
import 'package:code_steps/lesson_serializer.dart';
import 'package:code_steps/action/step_action.dart';
import 'package:code_steps/action/step_actions_provider.dart';
import 'package:code_steps/step_context_service.dart';
import 'package:ng_bootstrap/ng_bootstrap.dart';

@Component(
    selector: 'action-region-editor',
    templateUrl: 'html/action_region_editor_component.html',
    directives: const [
      NG_BOOTSTRAP_DIRECTIVES
    ],
    styles: const [
      '''
    :host { display: block; }
    '''
    ])
class ActionRegionEditorComponent {
  @Input()
  EditorActionRegion region;
  @Output()
  EventEmitter onDelete;
  @Output()
  EventEmitter onDataChange;

  StepContextService stepContextService;
  EnumStringHelper<StepActionType> esh;

  ActionRegionEditorComponent(this.stepContextService) {
    onDelete = new EventEmitter();
    onDataChange = new EventEmitter();
    esh = new EnumStringHelper<StepActionType>();
  }

  Set<StepActionType> get currentStepActions => region.stepData[stepContextService.stepIndex];
  set currentStepActions(Set<StepActionType> actions) => region.stepData[stepContextService.stepIndex] = actions;

  void deleteRegion() {
    onDelete.emit(region.marker.id);
    region = null;
  }

  Map<StepActionType, bool> get actionUIToggles => region.getActionStates(stepContextService.stepIndex);

  void updateSelected(StepActionType type, bool event) {
    if (currentStepActions == null) currentStepActions = new Set<StepActionType>();
    event ? currentStepActions.add(type) : currentStepActions.remove(type);
    onDataChange.emit(actionUIToggles);
  }
}
