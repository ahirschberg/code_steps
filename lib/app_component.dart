import 'package:angular2/core.dart' show Component, OnInit;
import 'code_guide_component.dart';
import 'step_context_service.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'html/app_component.html',
    styleUrls: const ['css/app_component.css'],
    directives: const [CodeGuideComponent]
)
class AppComponent implements OnInit {
  StepContextService stepContextService;
  String lessonName = 'polymorphism';

  AppComponent(this.stepContextService);

  void userSelectLesson() {
    stepContextService.selectLesson('static/lesson-$lessonName.json')
        .catchError((dynamic err) =>
          print('ERROR: $err'));
  }

  void ngOnInit() {
    userSelectLesson();
  }
}
