import 'dart:html';
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:code_steps/lesson_io.dart';

@Component(
    selector: 'lesson-list',
    templateUrl: 'html/lesson_list_component.html',
    directives: const [ROUTER_DIRECTIVES])
class LessonListComponent implements OnInit {
  LessonIO lessonIO;
  List lessons;
  LessonListComponent(this.lessonIO);

  @override
  ngOnInit() {
    lessons = window.localStorage.keys
        .where((String k) => k.startsWith(LessonIO.LESSON_PREFIX))
        .map((s) => s.replaceFirst(LessonIO.LESSON_PREFIX, ''))
        .toList();
  }
}
