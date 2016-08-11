import 'package:angular2/core.dart';
import 'package:ace/ace.dart' as ace;
import 'package:ace/proxy.dart';

@Component(
    selector: 'code-editor',
    templateUrl: 'html/code_editor_component.html',
    styles: const['''
    #ace-edit {
        margin: 0;
        position: absolute;
        top: 0;
        bottom: 0;
        left: 0;
        right: 0;
    }''']
)
class CodeEditorComponent implements OnInit {
  @override
  ngOnInit() {
    ace.implementation = ACE_PROXY_IMPLEMENTATION;
    ace.Editor editor = ace.edit('ace-edit');
    editor..theme = new ace.Theme.named(ace.Theme.SOLARIZED_DARK)
    ..session.mode = new ace.Mode.named(ace.Mode.JAVASCRIPT);
  }
}
