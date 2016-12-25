import 'dart:async';
import 'dart:developer';
import 'dart:html';
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:code_steps/action/lesson.dart';
import 'package:code_steps/action/step.dart';
import 'package:code_steps/editor/ace_editor_component.dart';
import 'package:code_steps/editor/action_region_editor_component.dart';
import 'package:code_steps/editor/lesson_code_editor_component.dart';
import 'package:code_steps/lesson_io.dart';
import 'package:code_steps/viewer/code_guide_component.dart';
import 'package:code_steps/step_context_service.dart';
import 'package:js/js.dart';
import 'package:observable/observable.dart';
import 'ace_facade.dart';

@Component(
    selector: 'lesson-editor',
    templateUrl: 'html/lesson_editor_component.html',
    styleUrls: const [
      'css/lesson_editor_component.css'
    ],
    directives: const [
      ActionRegionEditorComponent,
      CodeGuideComponent,
      AceEditorComponent,
      LessonCodeEditorComponent,
    ])
class LessonEditorComponent implements OnInit {
  StepContextService stepContextService;
  AceEditorComponent markdownEditor;
  LessonCodeEditorComponent codeEditor;
  StreamController _editorInitStreamController =
      new StreamController.broadcast();

  StreamController<PropertyChangeRecord<AceActionRegion>>
      activeRegionChangeController =
      new StreamController<PropertyChangeRecord<AceActionRegion>>.broadcast();
  Stream<PropertyChangeRecord<AceActionRegion>> activeRegionOnChange;

  List<Step> steps = [];
  Step get currentStep => steps[stepContextService.stepIndex];
  String lessonName;
  LessonIO _lessonIO;
  RouteParams _routeParams;

  LessonEditorComponent(
      this.stepContextService, this._routeParams, this._lessonIO);

  @override
  ngOnInit() {
    _editorInitStreamController.stream.listen(_onEditorReady);
    _editorInitStreamController.stream.take(2).drain().then(_onAllEditorsReady);

    stepContextService.onStepChange.listen(_onStepChange);
     activeRegionOnChange = activeRegionChangeController.stream;
  }

  // TODO
  void _onEditorReady(Editor aceController) {
//    aceController.theme = new ace.Theme.named(ace.Theme.SOLARIZED_DARK);
//    aceController.keyboardHandler =
//    new ace.KeyboardHandler.named(ace.KeyboardHandler.VIM);
//    _isVim = true;
  }

  void _onAllEditorsReady(_) {
    codeEditor.aceController.on("change", allowInterop((b, c) => print(b)));

    markdownEditor.aceController.renderer.setShowGutter(false);
    markdownEditor.aceController.session.setUseWrapMode(true);

    lessonName = _routeParams.get('lesson_name');
    if (lessonName != null) serializedRetrieve();
  }

  void _onStepChange(PropertyChangeRecord data) {
    markdownEditor.aceController
        .setValue(stepContextService.currentStep.explanation);
    codeEditor.aceController.setValue(stepContextService.currentStep.code);
  }

  void reset() {
    steps = [];
    codeEditor.cleanRegions();
  }

  Iterable getSavedLessons() {
    return window.localStorage.keys
        .where((k) => k.startsWith('lesson-'))
        .map((k) => [k, window.localStorage[k]]);
  }

  // FIXME
  void serializedInit(Lesson lesson) {
    reset();
    stepContextService.currentLesson = lesson;
//    codeEditor.addSerializedRegions(serializedEditData['regions']);
    codeEditorFilepath = "TODO"; // FIXME
  }

  setupMarkdownEditor(AceEditorComponent editor) {
    editor.aceController.session.setMode('ace/mode/markdown'); // FIXME?
    markdownEditor = editor;
    _editorInitStreamController.add(editor.aceController);
  }

  setupCodeEditor(LessonCodeEditorComponent code_editor) {
    codeEditor = code_editor;
    _editorInitStreamController.add(codeEditor.aceController);
  }

  bool _isVim = false;
  bool get vimModeEnabled => _isVim;
  set vimModeEnabled(value) {
    _isVim = value;
//    ace.KeyboardHandler mode = new ace.KeyboardHandler.named(value ? ace.KeyboardHandler.VIM : ace.KeyboardHandler.DEFAULT);
//    [codeEditor, markdownEditor].forEach((AceEditorComponent e) => e.aceController.keyboardHandler = mode);
  }

  String _codeEditorFilepath;
  get codeEditorFilepath => _codeEditorFilepath;
  set codeEditorFilepath(String newPath) {
    _updateCodeEditorFiletype(newPath);
    _codeEditorFilepath = newPath;
  }

  _updateCodeEditorFiletype(String filepath) {
    codeEditor.aceController.session.setMode('javascript'); // FIXME
  }

  serializedSave() {
    steps[stepContextService.stepIndex].explanation =
        markdownEditor.aceController.getValue();
    if (lessonName == null || lessonName.length == 0) {
      print('Cannot save an empty lesson name!');
    } else {
      _lessonIO.saveLesson(lessonName, this);
    }
  }

  serializedRetrieve() =>
      _lessonIO.smartLoadData(lessonName).then(serializedInit);

  Map toJson() => {
        'code': codeEditor.aceController.getValue(),
        'steps': steps,
        'meta': {'code_filename': _codeEditorFilepath}
      };
}
