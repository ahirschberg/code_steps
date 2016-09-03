import 'dart:async';

import 'dart:collection';
import 'dart:convert';
import 'dart:html';
import 'package:angular2/core.dart';
import 'package:code_steps/lesson_serializer.dart';

@Injectable()
class LessonLoader {
  static const String LESSON_PREFIX = 'lesson-';

  Future<HashMap> smartLoadData(lesson_name) {
    if (window.localStorage.containsKey(LESSON_PREFIX + lesson_name)) {
      return new Future.value(
          LessonSerializer.decode(window.localStorage[lesson_name]));
    } else {
      return HttpRequest
          .getString('static/$LESSON_PREFIX$lesson_name.json')
          .then((String value) => LessonSerializer.decode(value))
          .catchError((Object o) => print(o));
    }
  }
}
