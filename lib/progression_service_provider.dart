import 'package:angular2/core.dart';
import 'lesson_loader.dart';
import 'package:code_steps/progression_service.dart';

@Injectable()
progressionServiceFactory(LessonLoader lessonLoader) =>
    new ProgressionService(lessonLoader);

const progressionServiceProvider = const Provider(ProgressionService,
    useFactory: progressionServiceFactory,
    deps: const [LessonLoader]
);