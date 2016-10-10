import 'package:angular2/core.dart';
import 'package:code_steps/action/action_region.dart';
import 'package:code_steps/lesson_serializer.dart';
import 'package:code_steps/action/step_action.dart';
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
    :host .steps-picker {
        overflow-x: hidden;
        text-overflow: ellipsis;
        overflow-y: scroll;
    }
    :host .steps-picker > option {
        overflow: hidden;
        text-overflow: ellipsis;
    }
    :host .step-actions-picker {
        display: block;
    }
    '''
    ])
class ActionRegionEditorComponent {
  @Input()
  EditorActionRegion region;
  @Input()
  List<String> stepDescriptions;
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

  get selectedActionType => currentStepActions.first;
  set selectedActionType(StepActionType type) {
    currentStepActions.clear();
    currentStepActions.add(type);
  }
}
