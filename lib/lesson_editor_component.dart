import 'dart:async';
import 'dart:developer';
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
import 'package:fff/color.dart';

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

  @override
  ngOnInit() {
    ace.implementation = ACE_PROXY_IMPLEMENTATION;
    editorInitStreamController.stream.listen((aceController) {
      aceController.theme = new ace.Theme.named(ace.Theme.SOLARIZED_DARK);
      aceController.keyboardHandler =
          new ace.KeyboardHandler.named(ace.KeyboardHandler.VIM);
    });
  }

  Iterable getSavedLessons() {
    return window.localStorage.keys
        .where((k) => k.startsWith('lesson-'))
        .map((k) => [k, window.localStorage[k]]);
  }

  void initFromMap(Map serializedEditData) {
    codeEditor.aceController.setValue(serializedEditData['code']);
    markdownEditor.aceController.setValue(serializedEditData['expl']);
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
        'expl': markdownEditor.aceController.value,
        'regions': codeEditor.actionRegions.values.toList(growable: false)
      };
}

@Component(
    selector: 'ace-edit',
    template: '<pre>Not special :(</pre>',
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

  ActionRegion activeRegion;
  Map<int, ActionRegion> actionRegions = {};
  LessonCodeEditorComponent(ElementRef elementRef) : super(elementRef) {
    super.dom_id = code_edit_id;
  }

  @override
  ngOnInit() {
    super.ngOnInit();
    this.aceController.selection.onChangeCursor.listen(onData);
  }

  void addSerializedRegions(List regions) {
    regions.forEach((region_map) {
      ActionRegion r = addActionMarker(region_map['range'])
        ..stepData = LessonSerializer.transformMap(region_map['step_data'],
            key: LessonSerializer.destringifyInt,
            value: (v) => v.toSet());
      print('=====serialized region output=====');
      print(r);
    });
  }

  ActionRegion addActionMarker([ace.Range range = null]) {
    range ??= aceController.selectionRange;
    ActionRegion inserted = _insertMarker(range, 'cs-mark');
    activeRegion = inserted;
    return inserted;
  }

  removeActionMarker(int id) {
    actionRegions.remove(id);
    aceController.session.removeMarker(id);
  }

  int nextUniq = 0;
  ActionRegion _insertMarker(ace.Range selection, String tag) {
    String uniqClass = 'mark-${nextUniq++}';
    int id = aceController.session
        .addMarker(selection, tag + ' $uniqClass', type: ace.Marker.TEXT);
    actionRegions[id] = new ActionRegion(
        aceController.session.getMarkers()[id.toString()], uniqClass);
    return actionRegions[id];
  }

  void onData(Null) {
    activeRegion = getRegionAtCursor();
  }

  ActionRegion getRegionAtCursor() => actionRegions.values.firstWhere(
      (ActionRegion region) =>
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
      ActionRegion region, Map<StepActionType, bool> typeEnabledState) {
    Color c = null; // todo experimental
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
