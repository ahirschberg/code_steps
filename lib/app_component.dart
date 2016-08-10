import 'package:angular2/core.dart' show Component;
import 'package:angular2/router.dart';
import 'code_guide_component.dart';

@RouteConfig(const [
  const Route(
      path: '/lesson/:lesson_name',
      name: 'Lesson',
      component: CodeGuideComponent
  ),
  const Redirect(
      path: '/',
      redirectTo: const ['Lesson', const {'lesson_name': 'polymorphism'}]
  )
])

@Component(
    selector: 'my-app',
    templateUrl: 'html/app_component.html',
    styleUrls: const ['css/app_component.css'],
    directives: const [CodeGuideComponent, ROUTER_DIRECTIVES]
)
class AppComponent {}
