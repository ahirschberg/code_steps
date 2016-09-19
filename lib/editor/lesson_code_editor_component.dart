import 'dart:js';
import 'package:angular2/core.dart';
import 'package:code_steps/action/action_region.dart';
import 'package:code_steps/editor/ace_editor_component.dart';
import 'package:code_steps/action/step_action.dart';
import 'package:code_steps/step_context_service.dart';
import 'package:fff/color.dart';

import 'package:code_steps/editor/jss_interop.dart' as jss;
import 'package:ace/ace.dart' as ace;

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
  @Output('onInit')
  get init => super.init; // workaround for annotations not inheriting properly

  EditorActionRegion activeRegion;
  Map<int, EditorActionRegion> actionRegions = {};
  StepContextService stepContextService;
  LessonCodeEditorComponent(ElementRef elementRef, this.stepContextService)
      : super(elementRef) {
    super.dom_id = code_edit_id;
  }

  @override
  ngOnInit() {
    super.ngOnInit();
    this.aceController.selection.onChangeCursor.listen(onData);
    stepContextService.onStepChange.listen((e) {
      actionRegions.values.forEach((r) =>
          recolorRegion(r, r.getActionStates(stepContextService.stepIndex)));
    });
  }

  cleanRegions() {
    actionRegions.keys.toSet().forEach((id) => removeActionMarker(id));
    actionRegions.clear();
  }

  void addSerializedRegions(List regions) {
    regions.forEach((ActionRegion region) {
      EditorActionRegion r = addActionMarker(region.range)
        ..stepData = region.stepData;
      recolorRegion(r, r.getActionStates(stepContextService.stepIndex));
    });
  }

  EditorActionRegion addActionMarker([ace.Range range = null]) {
    range ??= aceController.selectionRange;
    EditorActionRegion inserted = _insertMarker(range, 'cs-mark');
    activeRegion = inserted;
    return inserted;
  }

  removeActionMarker(int id) {
    print(aceController.session.getMarkers().length);
    aceController.session.removeMarker(id);
    print(aceController.session.getMarkers().length);
    actionRegions.remove(id);
  }

  int nextUniq = 0;
  EditorActionRegion _insertMarker(ace.Range selection, String tag) {
    String uniqClass = 'mark-${nextUniq++}';
    int id = aceController.session
        .addMarker(selection, tag + ' $uniqClass', type: ace.Marker.TEXT);
    actionRegions[id] = new EditorActionRegion(
        aceController.session.getMarkers()[id.toString()], uniqClass);
    return actionRegions[id];
  }

  void onData(Null) {
    activeRegion = getRegionAtCursor();
  }

  EditorActionRegion getRegionAtCursor() {
    Iterable<EditorActionRegion> regions = actionRegions.values.where(
        (region) =>
            region.marker.className.contains('cs-mark') &&
            region.marker.range.comparePoint(aceController.selection.cursor) ==
                0);
    if (regions.isNotEmpty) {
      return regions.skip(1).fold(
          regions.first,
          (smallest, e) =>
              smallest.range.containsRange(e.range) ? e : smallest);
    }
    return null;
  }

  static const green = const Color(80, 131, 30, 0.35);
  static const blue = const Color(53, 191, 188, 0.2);
  static const red = const Color(126, 13, 13, 0.68);
  static const purple = const Color(197, 23, 158, 0.25);
  static const yellow = const Color(79, 76, 15, 0.66);
  recolorRegion(
      EditorActionRegion region, Map<StepActionType, bool> typeEnabledState) {
    Color c = null;
    Function addColor =
        (Color base, Color toAdd) => base == null ? toAdd : toAdd + base;
    if (typeEnabledState[StepActionType.Pass] == true) {
      c = addColor(c, green);
    }
    if (typeEnabledState[StepActionType.Fail] == true) {
      c = addColor(c, red);
    }
    if (typeEnabledState[StepActionType.Spotlight] == true ||
        typeEnabledState[StepActionType.LineSpotlight] == true) {
      c = addColor(c, yellow);
    }
    if (typeEnabledState[StepActionType.Show] == true ||
        typeEnabledState[StepActionType.Hide] == true) {
      c = addColor(c, blue);
    }
    // FIXME remove canary once dart2js updated with proper object support for interops
    jss.set('div.cs-mark.${region.uniqClass}',
        new JsObject.jsify({'background-color': c.toString(), 'CANARY': true}));
  }
}
