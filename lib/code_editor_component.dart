import 'dart:js';
import 'package:angular2/core.dart';
import 'package:ace/ace.dart' as ace;
import 'package:ace/proxy.dart';
import 'package:code_steps/action_region_editor_component.dart';
import 'package:code_steps/lesson_serializer.dart';
import 'package:code_steps/step_action.dart';
import 'package:code_steps/code_guide_component.dart';
import 'package:code_steps/step_context_service.dart';
import 'jss_interop.dart' as jss;
import 'package:fff/color.dart';

@Component(
    selector: 'code-editor',
    templateUrl: 'html/code_editor_component.html',
    directives: const [
      ActionRegionEditorComponent,
      CodeGuideComponent
    ],
    styles: const [
      '''
    #code-edit, #explanation-edit {
        margin: 0;
        width: 640px;
        height: 480px;
        font-size: 1.2rem;
    }
    :host div.cs-mark {
        background-color: rgba(132,132,132,0.25);
        position: absolute;
    }
    '''
    ])
class CodeEditorComponent implements OnInit {
  ActionRegion activeRegion;
  Map<int, ActionRegion> actionRegions = {};
  List<ace.Editor> editors;
  ace.Editor codeEditor;

  StepContextService stepContextService;

  CodeEditorComponent(this.stepContextService);

  @override
  ngOnInit() {
    ace.implementation = ACE_PROXY_IMPLEMENTATION;
    codeEditor = setupCodeEditor('code-edit');
    editors = [codeEditor, setupMdEditor('explanation-edit')];
    editors.forEach((e) {
      e.theme = new ace.Theme.named(ace.Theme.SOLARIZED_DARK);
      e.keyboardHandler = new ace.KeyboardHandler.named(ace.KeyboardHandler.VIM);
    });
  }

  ace.Editor setupCodeEditor(String selector) {
    ace.Editor editor = ace.edit(selector);
    editor.selection.onChangeCursor.listen(onData);
    return editor;
  }

  ace.Editor setupMdEditor(String selector) {
    ace.Editor editor = ace.edit(selector);
    editor.session.mode = new ace.Mode.named(ace.Mode.MARKDOWN);
    return editor;
  }

  addActionMarker() {
    _insertMarker(codeEditor.selectionRange, 'cs-mark');
  }

  removeActionMarker(int id) {
    actionRegions.remove(id);
    codeEditor.session.removeMarker(id);
  }

  int nextUniq = 0;
  _insertMarker(ace.Range selection, String tag) {
    String uniqClass = 'mark-${nextUniq++}';
    int id = codeEditor.session
        .addMarker(selection, tag + ' $uniqClass', type: ace.Marker.TEXT);
    actionRegions[id] =
        new ActionRegion(codeEditor.session.getMarkers()[id.toString()], uniqClass);
    activeRegion = getRegionAtCursor();
  }

  updateCodeEditorFiletype(String filepath) {
    codeEditor.session.mode = new ace.Mode.forFile(filepath);
  }
  void onData(Null) {
    activeRegion = getRegionAtCursor();
  }

  ActionRegion getRegionAtCursor() => actionRegions.values.firstWhere(
      (ActionRegion region) =>
          region.marker.className.contains('cs-mark') &&
          region.marker.range.comparePoint(codeEditor.selection.cursor) == 0,
      orElse: () {});

  _updateMarkerFields(ace.Marker oldMarker,
      {ace.Range newRange: null, String newClass: null}) {
    ace.Range desiredRange = newRange ?? oldMarker.range;
    String desiredClass = newClass ?? oldMarker.className;
    int newId = codeEditor.session.addMarker(desiredRange, desiredClass,
        type: oldMarker.type, inFront: oldMarker.inFront);
    actionRegions[newId] = actionRegions[oldMarker.id];
    removeActionMarker(oldMarker.id);
  }

  jsonTest() {
    String jsonData = LessonSerializer.encode(actionRegions.values.toList());
    print(jsonData);
    print(LessonSerializer.decode(jsonData));
  }

  static const green = const Color(80, 131, 30, 0.35);
  static const blue = const Color(53, 191, 188, 0.2);
  static const red = const Color(126, 13, 13, 0.68);
  static const purple = const Color(197, 23, 158, 0.25);
  static const yellow = const Color(79, 76, 15, 0.66);
  recolorActiveRegion(Map<StepActionType, bool> typeEnabledState) {
    Color c = null;
    if (typeEnabledState[StepActionType.Pass] == true) {
      c = green;
    } else if (typeEnabledState[StepActionType.Fail] == true) {
      c = red;
    } else if (typeEnabledState[StepActionType.Spotlight] == true || typeEnabledState[StepActionType.LineSpotlight]) {
      c = yellow;
    }
    jss.set('div.cs-mark.${activeRegion.uniqClass}',
        new JsObject.jsify({'background-color': c.toString()}));
  }
}

class ActionRegion {
  ace.Marker marker;
  String uniqClass;
  Map<int, Set<StepActionType>> stepData = {};

  ActionRegion(this.marker, this.uniqClass);

  String toString() => "ActionEditRegion($marker, $stepData)";

  Map toJson() {
    return {
      'range': marker.range,
      'stepData': LessonSerializer.stringifyMapData(stepData,
          valuesTransformer: LessonSerializer.stepActionTypeSetTransformer)
    };
  }
}
