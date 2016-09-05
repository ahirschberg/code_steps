import 'package:angular2/core.dart';
import 'package:code_steps/lesson_io.dart';
import 'package:code_steps/step_context_service.dart';
import 'package:code_steps/action/step_actions_provider.dart';

@Injectable()
stepContextServiceFactory(LessonIO lessonIO, StepActionsProvider stepActionsProvider) =>
    new StepContextService(lessonIO);

const stepContextServiceProvider = const Provider(StepContextService,
    useFactory: stepContextServiceFactory,
    deps: const [LessonIO, StepActionsProvider]
);