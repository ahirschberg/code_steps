import 'package:angular2/core.dart';
import 'package:code_steps/lesson_loader.dart';
import 'package:code_steps/step_context_service.dart';
import 'package:code_steps/step_actions_provider.dart';

@Injectable()
stepContextServiceFactory(LessonLoader lessonLoader, StepActionsProvider stepActionsProvider) =>
    new StepContextService(lessonLoader);

const stepContextServiceProvider = const Provider(StepContextService,
    useFactory: stepContextServiceFactory,
    deps: const [LessonLoader, StepActionsProvider]
);