import 'package:angular2/core.dart';
import 'lesson_loader.dart';
import 'package:code_steps/progression_service.dart';
import 'package:code_steps/step_actions_provider.dart';

@Injectable()
progressionServiceFactory(LessonLoader lessonLoader, StepActionsProvider stepActionsProvider) =>
    new ProgressionService(lessonLoader, stepActionsProvider);

const progressionServiceProvider = const Provider(ProgressionService,
    useFactory: progressionServiceFactory,
    deps: const [LessonLoader, StepActionsProvider]
);