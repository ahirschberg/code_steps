import 'dart:collection';
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:code_steps/lesson_loader.dart';

@Component(
    selector: 'lesson-list',
    templateUrl: 'html/lesson_list_component.html',
    directives: const [ROUTER_DIRECTIVES]
)
class LessonListComponent implements OnInit {
  LessonLoader lessonLoader;
  List lessons;
  LessonListComponent(this.lessonLoader);

  @override
  ngOnInit() {
    lessonLoader.loadData('static/lessons.json').then((HashMap lessons_json) {
      this.lessons = lessons_json['lessons'];
    });
  }
}