import 'package:angular2/core.dart';
import 'package:code_steps/editor/lesson_code_editor_component.dart';
import 'package:code_steps/lesson_serializer.dart';
import 'package:code_steps/action/step_action.dart';
import 'package:code_steps/step_context_service.dart';

@Component(
    selector: 'action-region-editor',
    templateUrl: 'html/action_region_editor_component.html',
    directives: const [
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
  AceActionRegion guiRegion;
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

  void deleteRegion() {
    onDelete.emit(guiRegion.marker.id);
    guiRegion = null;
  }

  get selectedActionType => guiRegion.region.actions.first;
  set selectedActionType(StepActionType type) {
    guiRegion.region.actions
      ..clear()
      ..add(type);
  }
}
