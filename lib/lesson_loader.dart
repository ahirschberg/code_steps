import 'dart:async';

import 'dart:collection';
import 'dart:convert';
import 'dart:html';
import 'package:angular2/core.dart';
import 'package:code_steps/lesson_serializer.dart';


@Injectable()
class LessonLoader {
  Future<HashMap> loadData(url) =>
      new Future.value(LessonSerializer.decode(window.localStorage[url]));
//      HttpRequest.getString(url).then((String value) {
//        return JSON.decode(value);
//      }).catchError((Object o) => print(o));
}

