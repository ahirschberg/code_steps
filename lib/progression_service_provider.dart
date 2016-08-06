import 'package:angular2/core.dart';
import 'lesson_loader.dart';
import 'package:code_steps/progression_service.dart';
import 'package:code_steps/step_cmds_directive.dart';

@Injectable()
progressionServiceFactory(LessonLoader lessonLoader, StepActionsProvider stepCommandsDirective) =>
    new ProgressionService(lessonLoader, stepCommandsDirective);

const progressionServiceProvider = const Provider(ProgressionService,
    useFactory: progressionServiceFactory,
    deps: const [LessonLoader, StepActionsProvider]
);