import 'package:angular2/core.dart' show Component, OnInit;
import 'code_guide_component.dart';
import 'progression_service.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'html/app_component.html',
    styleUrls: const ['css/app_component.css'],
    directives: const [CodeGuideComponent]
)
class AppComponent implements OnInit {
  ProgressionService progressionService;
  String lessonName = 'polymorphism';

  AppComponent(this.progressionService);

  void userSelectLesson() {
    progressionService.selectLesson('static/lesson-$lessonName.json')
        .catchError((dynamic err) =>
          print('ERROR: $err'));
  }

  void ngOnInit() {
    userSelectLesson();
  }
}
