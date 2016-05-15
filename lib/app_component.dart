import 'package:angular2/core.dart' show Component;
import 'code_guide_component.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'app_component.html',
    directives: const [CodeGuideComponent]
)
class AppComponent {}
