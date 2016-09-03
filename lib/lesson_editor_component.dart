import 'dart:async';
import 'dart:html';
import 'dart:js';
import 'package:angular2/core.dart';
import 'package:ace/ace.dart' as ace;
import 'package:ace/proxy.dart';
import 'package:code_steps/action_region.dart';
import 'package:code_steps/action_region_editor_component.dart';
import 'package:code_steps/lesson_serializer.dart';
import 'package:code_steps/step_action.dart';
import 'package:code_steps/code_guide_component.dart';
import 'package:code_steps/step_context_service.dart';
import 'jss_interop.dart' as jss;
import 'package:code_steps/util.dart';
import 'package:fff/color.dart';
import 'package:observe/observe.dart';

@Component(
    selector: 'lesson-editor',
    templateUrl: 'html/lesson_editor_component.html',
    directives: const [
      ActionRegionEditorComponent,
      CodeGuideComponent,
      AceEditorComponent,
      LessonCodeEditorComponent
    ])
class LessonEditorComponent implements OnInit {
  StepContextService stepContextService;
  LessonEditorComponent(this.stepContextService);
  AceEditorComponent markdownEditor;
  LessonCodeEditorComponent codeEditor;
  StreamController editorInitStreamController = new StreamController();
  List<String> explanations = [''];

  @override
  ngOnInit() {
    ace.implementation = ACE_PROXY_IMPLEMENTATION;
    editorInitStreamController.stream.listen((aceController) {
      aceController.theme = new ace.Theme.named(ace.Theme.SOLARIZED_DARK);
      aceController.keyboardHandler =
          new ace.KeyboardHandler.named(ace.KeyboardHandler.VIM);
    });
    Util.filterChangeStreamByProp(stepContextService.changes, [#changeStep]).listen((PropertyChangeRecord data) {
      print('data was $data');
      explanations[data.oldValue] = markdownEditor.aceController.value;
      if (explanations.length <= data.newValue) {
        explanations.add(markdownEditor.aceController.value);
      } else {
        markdownEditor.aceController.setValue(explanations[data.newValue]);
      }
    });
  }

  Iterable getSavedLessons() {
    return window.localStorage.keys
        .where((k) => k.startsWith('lesson-'))
        .map((k) => [k, window.localStorage[k]]);
  }

  void initFromMap(Map serializedEditData) {
    codeEditor.aceController.setValue(serializedEditData['code']);
    explanations = serializedEditData['expl'];
    markdownEditor.aceController.setValue(explanations[stepContextService.stepIndex]);
    codeEditor.addSerializedRegions(serializedEditData['regions']);
  }

  setupMarkdownEditor(AceEditorComponent editor) {
    editor.aceController.session.mode = new ace.Mode.named(ace.Mode.MARKDOWN);
    markdownEditor = editor;
    editorInitStreamController.add(editor.aceController);
  }

  setupCodeEditor(LessonCodeEditorComponent code_editor) {
    codeEditor = code_editor;
    editorInitStreamController.add(codeEditor.aceController);
  }

  String _codeEditorFilepath;
  get codeEditorFilepath => _codeEditorFilepath;
  set codeEditorFilepath(String newPath) {
    _updateCodeEditorFiletype(newPath);
    _codeEditorFilepath = newPath;
  }

  _updateCodeEditorFiletype(String filepath) {
    codeEditor.aceController.session.mode = new ace.Mode.forFile(filepath);
  }

  localStorageSave() {
    String jsonData = LessonSerializer.encode(this);
    print(jsonData);
    window.localStorage['lesson-test'] = jsonData;
  }

  localStorageRetrieve() {
    Map decoded = LessonSerializer.decode(window.localStorage['lesson-test']);
    initFromMap(decoded);
  }

  Map toJson() => {
        'code': codeEditor.aceController.value,
        'expl': explanations,
        'regions': codeEditor.actionRegions.values.toList(growable: false)
      };
}

@Component(
    selector: 'ace-edit',
    template: '',
    styleUrls: const ['css/ace_editor_component.css'])
class AceEditorComponent implements OnInit {
  static int _uniq_id_num = 0;
  ace.Editor aceController;
  ElementRef elementRef;
  @Output('onInit')
  EventEmitter init = new EventEmitter();

  AceEditorComponent(this.elementRef) {
    print(elementRef.nativeElement.id);
  }

  ngOnInit() {
    if (dom_id.length == 0) dom_id = 'ace-edit-${_uniq_id_num++}';
    aceController = ace.edit(elementRef.nativeElement.id);
    init.emit(this);
  }

  String get dom_id => elementRef.nativeElement.id;
  set dom_id(id) => elementRef.nativeElement.id = id;
}


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
  LessonCodeEditorComponent(ElementRef elementRef, this.stepContextService) : super(elementRef) {
    super.dom_id = code_edit_id;
  }

  @override
  ngOnInit() {
    super.ngOnInit();
    this.aceController.selection.onChangeCursor.listen(onData);
    Util.filterChangeStreamByProp(stepContextService.changes, const [#changeStep]).listen((e) {
      actionRegions.values.forEach((r) => recolorRegion(r, r.getActionStates(stepContextService.stepIndex)));
    });
  }

  void addSerializedRegions(List regions) {
    regions.forEach((ActionRegion region) {
      print('Serialized step data: ${region.stepData}');
      EditorActionRegion r = addActionMarker(region.range)
        ..stepData = region.stepData;
      recolorRegion(r, r.getActionStates(stepContextService.stepIndex));
      print('=====serialized region output=====');
      print(r);
    });
  }

  EditorActionRegion addActionMarker([ace.Range range = null]) {
    range ??= aceController.selectionRange;
    EditorActionRegion inserted = _insertMarker(range, 'cs-mark');
    activeRegion = inserted;
    print(activeRegion.stepData.runtimeType);
    return inserted;
  }

  removeActionMarker(int id) {
    actionRegions.remove(id);
    aceController.session.removeMarker(id);
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

  EditorActionRegion getRegionAtCursor() => actionRegions.values.firstWhere(
      (EditorActionRegion region) =>
          region.marker.className.contains('cs-mark') &&
          region.marker.range.comparePoint(aceController.selection.cursor) == 0,
      orElse: () {});

  _updateMarkerFields(ace.Marker oldMarker,
      {ace.Range newRange: null, String newClass: null}) {
    ace.Range desiredRange = newRange ?? oldMarker.range;
    String desiredClass = newClass ?? oldMarker.className;
    int newId = aceController.session.addMarker(desiredRange, desiredClass,
        type: oldMarker.type, inFront: oldMarker.inFront);
    actionRegions[newId] = actionRegions[oldMarker.id];
    removeActionMarker(oldMarker.id);
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
    jss.set('div.cs-mark.${region.uniqClass}',
        new JsObject.jsify({'background-color': c.toString()}));
  }
}
