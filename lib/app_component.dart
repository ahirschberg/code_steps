import 'package:angular2/core.dart' show Component;
import 'code_guide_component.dart';
import 'progression_service.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'app_component.html',
    directives: const [CodeGuideComponent],
    providers: const [ProgressionService]
)
class AppComponent {}
