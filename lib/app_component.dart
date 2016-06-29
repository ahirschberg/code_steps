import 'package:angular2/core.dart' show Component;
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
  String lessonName = '';

  AppComponent(this.progressionService);

  void userSelectLesson() {
    print('loading $lessonName');
    progressionService.selectLesson('/static/lesson-$lessonName.json');
  }
}
