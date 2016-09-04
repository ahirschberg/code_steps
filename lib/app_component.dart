import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:code_steps/editor/lesson_editor_component.dart';
import 'package:code_steps/code_guide_component.dart';
import 'package:code_steps/lesson_list_component.dart';

@MirrorsUsed(override: '*', symbols: '') // we don't need any jsonx mirrors.
import 'dart:mirrors';

@RouteConfig(const [
  const Route(
      path: '/lesson/:lesson_name',
      name: 'Lesson',
      component: CodeGuideComponent
  ),
  const Route(
      path: '/lessons',
      name: 'Lesson List',
      component: LessonListComponent
  ),
  const Route(
      path: '/edit/:lesson_name',
      name: 'Lesson Editor',
      component: LessonEditorComponent
  ),
  const Route(
      path: '/new',
      name: 'New Lesson',
      component:  LessonEditorComponent
  ),
  const Redirect(
      path: '/',
      //redirectTo: const ['Lesson List']
      redirectTo: const ['Lesson', const {'lesson_name': 'tutorial'}]
  )
])

@Component(
    selector: 'my-app',
    templateUrl: 'html/app_component.html',
    styleUrls: const ['css/app_component.css'],
    directives: const [CodeGuideComponent, ROUTER_DIRECTIVES]
)
class AppComponent {}
