import 'package:angular2/core.dart' show Component, ViewEncapsulation;
import 'code_guide_component.dart';
import 'progression_service.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'html/app_component.html',
    styleUrls: const ['css/app_component.css'],
    directives: const [CodeGuideComponent]
)
class AppComponent {
  ProgressionService progressionService;

  AppComponent(this.progressionService);
}
