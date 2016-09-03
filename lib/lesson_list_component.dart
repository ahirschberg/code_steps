import 'dart:html';
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:code_steps/lesson_loader.dart';

@Component(
    selector: 'lesson-list',
    templateUrl: 'html/lesson_list_component.html',
    directives: const [ROUTER_DIRECTIVES])
class LessonListComponent implements OnInit {
  LessonLoader lessonLoader;
  List lessons;
  LessonListComponent(this.lessonLoader);

  @override
  ngOnInit() {
    lessons = window.localStorage.keys
        .where((String k) => k.startsWith(LessonLoader.LESSON_PREFIX))
        .map((s) => s.replaceFirst(LessonLoader.LESSON_PREFIX, ''))
        .toList();
  }
}
