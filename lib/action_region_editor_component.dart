import 'package:angular2/core.dart';
import 'package:code_steps/code_editor_component.dart';
import 'package:code_steps/step_actions_provider.dart';

@Component(
  selector: 'action-region-editor',
  templateUrl: 'html/action_region_editor_component.html',
    styles: const ['''
    :host { display: block; }
    ''']
)
class ActionRegionEditorComponent {
  StepActionsProvider stepActionsProvider;
  ActionRegionEditorComponent(this.stepActionsProvider) {
    emitter = new EventEmitter();
  }
  @Input() ActionRegion region;
  @Output('onDelete') EventEmitter emitter;

  void deleteRegion() {
    emitter.emit(region.marker.id);
  }
}