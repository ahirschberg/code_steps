import 'package:angular2/core.dart';
import 'package:ace/ace.dart' as ace;

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
  }

  ngOnInit() {
    if (dom_id.length == 0) dom_id = 'ace-edit-${_uniq_id_num++}';
    aceController = ace.edit(elementRef.nativeElement.id);
    init.emit(this);
  }

  String get dom_id => elementRef.nativeElement.id;
  set dom_id(id) => elementRef.nativeElement.id = id;
}
