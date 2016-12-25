import 'dart:async';
import 'dart:developer';
import 'dart:js';
import 'package:angular2/core.dart';
import 'package:code_steps/js_map.dart';
import 'package:code_steps/action/action_region.dart';
import 'package:code_steps/action/step.dart';
import 'package:code_steps/editor/ace_editor_component.dart';
import 'jss_interop.dart' as jss;
import 'package:code_steps/editor/ace_facade.dart';
import 'package:code_steps/step_context_service.dart';
import 'package:fff/color.dart';
import 'package:js/js.dart';
import 'package:observable/observable.dart';

@Component(selector: 'ace-code-edit', template: '', styles: const [
  '''
    :host div.cs-mark {
        background-color: rgba(132,132,132,0.25);
        position: absolute;
    }
    '''
], styleUrls: const [
  'css/ace_editor_component.css'
])
class LessonCodeEditorComponent extends AceEditorComponent implements OnInit {
  static const String code_edit_id = 'lesson-code-edit';
  @Input()
  StreamController<PropertyChangeRecord<AceRegionBundle>> activeRegionChangeController;
  @Output('onInit')
  get init => super.init; // workaround for annotations not inheriting properly

  AceRegionBundle _activeRegion = new AceRegionBundle(null, null, null);
  AceRegionBundle get activeRegion => _activeRegion;

  Map<int, AceRegionBundle> guiRegions = new Map();

  StepContextService stepContextService;
  LessonCodeEditorComponent(ElementRef elementRef, this.stepContextService)
      : super(elementRef) {
    super.dom_id = code_edit_id;
  }

  @override
  ngOnInit() {
    super.ngOnInit();
    this.aceController.selection.on("changeCursor", allowInterop(onData));
    stepContextService.onStepChange.listen((e) {
      cleanRegions();
      stepContextService.currentStep.activeRegions.forEach((r) => _addRegionToEditor(r));
    });
  }

  cleanRegions() {
    guiRegions.keys.toSet().forEach((id) => removeActionMarker(id));
    guiRegions.clear();
  }

  _addRegionToEditor(ActionRegion r) {
    AceRegionBundle guiRegion = new AceRegionBundle(null, 'cs-mark', r);
    return _insertMarker(guiRegion);
  }

  removeActionMarker(int id) {
    aceController.session.removeMarker(id);
  }

  int nextUniq = 0;
  _insertMarker(AceRegionBundle aceBundle) {
    String uniqClass = 'mark-${nextUniq++}';
    int id = aceController.session.addMarker(aceBundle.region.range,
        aceBundle.css_class + ' $uniqClass', "text", true); // fixme
    Marker obj = new JsMap<Marker>(aceController.session.getMarkers(true))[id];
    aceBundle.marker = obj;
    guiRegions[id] = aceBundle;
    return id;
  }

  void onData(event, Selection s) {
    AceRegionBundle oldRegion = _activeRegion;
    _activeRegion = getRegionAtCursor();
    activeRegionChangeController.add(new PropertyChangeRecord(this, #activeRegion, oldRegion, _activeRegion));
  }

  AceRegionBundle getRegionAtCursor() {
    Iterable<AceRegionBundle> regions = guiRegions.values.where((region) =>
        region.marker.clazz.contains('cs-mark') &&
        region.marker.range.comparePoint(aceController.selection.getCursor()) ==
            0);
    if (regions.isNotEmpty) {
      return regions.fold(
          regions.first,
          (smallest, e) => smallest.marker.range.containsRange(e.marker.range)
              ? e
              : smallest);
    }
    return null;
  }

  static const green = const Color(80, 131, 30, 0.35);
  static const blue = const Color(53, 191, 188, 0.2);
  static const red = const Color(126, 13, 13, 0.68);
  static const purple = const Color(197, 23, 158, 0.25);
  static const yellow = const Color(79, 76, 15, 0.66);
  recolorRegion(AceRegionBundle aceBundle) {
    Color c = purple;
    // FIXME remove canary once dart2js updated with proper object support for interops
    jss.set('div.cs-mark.${aceBundle.marker.clazz}',
        new JsObject.jsify({'background-color': c.toString(), 'CANARY': true}));
  }

  void addActionMarker() {
    Selection selection = aceController.session.getSelection();
    print(
        "selection text: ${aceController.session.getTextRange(selection.getRange())}");
    _addRegionToEditor(new ActionRegion(selection.getRange()));
  }
}

class AceRegionBundle {
  Marker marker;
  String css_class;
  ActionRegion region;
  AceRegionBundle(this.marker, this.css_class, this.region);

  String toString() => "Bundle: ${marker.id}, $region";
}
