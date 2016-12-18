import 'dart:async';

import 'dart:collection';
import 'dart:html';
import 'package:angular2/core.dart';
import 'package:code_steps/action/lesson.dart';
import 'package:code_steps/editor/lesson_editor_component.dart';
import 'package:code_steps/lesson_serializer.dart';

@Injectable()
class LessonIO {
  static const String LESSON_PREFIX = 'lesson-';

  Future<Lesson> smartLoadData(lesson_name) {
      return _loadLessonString(lesson_name).then((String value) {
        return Lesson.deserialize(LessonSerializer.decode(value));
      });
  }

  Future<String> _loadLessonString(lesson_name) =>
      HttpRequest.getString('static/$LESSON_PREFIX$lesson_name.json');

  void saveLesson(String lesson_name, LessonEditorComponent toSave) {
    String encoded = LessonSerializer.encode(toSave);
    _saveLessonString(lesson_name, encoded);
  }

  _saveLessonString(lesson_name, encoded) =>
      window.localStorage[LESSON_PREFIX + lesson_name] = encoded;
}
