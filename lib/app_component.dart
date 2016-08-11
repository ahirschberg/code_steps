import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'code_guide_component.dart';
import 'package:code_steps/lesson_list_component.dart';

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
  const Redirect(
      path: '/',
      redirectTo: const ['Lesson List']
  )
])

@Component(
    selector: 'my-app',
    templateUrl: 'html/app_component.html',
    styleUrls: const ['css/app_component.css'],
    directives: const [CodeGuideComponent, ROUTER_DIRECTIVES]
)
class AppComponent {}
