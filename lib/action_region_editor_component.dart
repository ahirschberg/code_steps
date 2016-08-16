import 'package:angular2/core.dart';
import 'package:code_steps/code_editor_component.dart';
import 'package:code_steps/step_action.dart';
import 'package:code_steps/step_actions_provider.dart';
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
class ActionRegionEditorComponent implements OnChanges {
  @Input()
  ActionRegion region;
  @Output()
  EventEmitter onDelete;

  StepActionsProvider stepActionsProvider;
  StepContextService stepContextService;
  EnumStringHelper<StepActionType> esh;
  Set<StepActionType> get currentStepActions {
    if (!region.stepData.containsKey(stepContextService.stepIndex)) {
      region.stepData[stepContextService.stepIndex] =
          new Set<StepActionType>();
    }
    return region.stepData[stepContextService.stepIndex];
  }

  ActionRegionEditorComponent(
      this.stepActionsProvider, this.stepContextService) {
    onDelete = new EventEmitter();
    esh = new EnumStringHelper<StepActionType>();
  }

  void deleteRegion() {
    onDelete.emit(region.marker.id);
    region = null;
  }

  Map<StepActionType, bool> _actionUIToggles;
  Map<StepActionType, bool> get actionUIToggles {
    _actionUIToggles ??= {};
    currentStepActions.forEach((t) => _actionUIToggles[t] = true);
    StepActionType.values
        .where((t) => !_actionUIToggles.containsKey(t))
        .forEach((t) => _actionUIToggles[t] = false);
    return _actionUIToggles;
  }

  void updateSelected(StepActionType type, bool event) {
    actionUIToggles[type] = event;
    event ? currentStepActions.add(type) : currentStepActions.remove(type);
  }

  @override
  void ngOnChanges(Map<String, SimpleChange> changes) {
    if(changes.containsKey('region')) {
      _actionUIToggles = {};
    }
  }
}
