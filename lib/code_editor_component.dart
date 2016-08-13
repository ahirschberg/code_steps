import 'dart:developer';
import 'package:angular2/core.dart';
import 'package:ace/ace.dart' as ace;
import 'package:ace/proxy.dart';
import 'package:code_steps/action_region_editor_component.dart';
import 'package:code_steps/step_action.dart';

@Component(
    selector: 'code-editor',
    templateUrl: 'html/code_editor_component.html',
    directives: const [ActionRegionEditorComponent],
    styles: const ['''
    #ace-edit {
        margin: 0;
        width: 640px;
        height: 480px;
        font-size: 1.2rem;
    }
    :host div.c-frm {
        background-color: gray;
        position: absolute;
    }
    '''
    ])
class CodeEditorComponent implements OnInit {
  ace.Editor editor;
  ActionRegion activeRegion;
  Map<int, ActionRegion> actionRegions = {};

  @override
  ngOnInit() {
    ace.implementation = ACE_PROXY_IMPLEMENTATION;
    editor = ace.edit('ace-edit');
    editor
      ..theme = new ace.Theme.named(ace.Theme.SOLARIZED_DARK)
      ..session.mode = new ace.Mode.named(ace.Mode.RUBY);
    editor.keyboardHandler =
        new ace.KeyboardHandler.named(ace.KeyboardHandler.VIM);

    editor.selection.onChangeCursor.listen(onData);
  }

  addActionMarker() {
    _insertMarker(editor.selectionRange, 'c-frm');
  }

  removeActionMarker(int id) {
    actionRegions.remove(id);
    editor.session.removeMarker(id);
  }

  _insertMarker(ace.Range selection, String tag) {
    int id = editor.session.addMarker(selection, tag, type: ace.Marker.TEXT);
    actionRegions[id] =
        new ActionRegion(editor.session.getMarkers()[id.toString()]);
  }

  void onData(Null) {
    print('onData called');
    activeRegion = getRegionAtCursor();
  }

  ActionRegion getRegionAtCursor() =>
      actionRegions.values.firstWhere((ActionRegion region) =>
        region.marker.className.contains('c-frm') &&
        region.marker.range.comparePoint(editor.selection.cursor) == 0, orElse: () {});

  _updateMarkerFields(ace.Marker oldMarker,
      {ace.Range newRange: null, String newClass: null}) {
    ace.Range desiredRange = newRange ?? oldMarker.range;
    String desiredClass = newClass ?? oldMarker.className;
    int newId = editor.session.addMarker(desiredRange, desiredClass,
        type: oldMarker.type, inFront: oldMarker.inFront);
    actionRegions[newId] = actionRegions[oldMarker.id];
    removeActionMarker(oldMarker.id);
  }
}

class ActionRegion {
  ace.Marker marker;
  Map<int, List<StepActionModel>> stepData = {};

  ActionRegion(this.marker);

  String toString() => "ActionEditRegion($marker, $stepData)";
}
