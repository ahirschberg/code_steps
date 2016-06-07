import 'dart:async';

import 'dart:collection';
import 'dart:html';
import 'dart:convert';
import 'package:angular2/core.dart';

@Injectable()
class LessonLoader {
  Future<HashMap> loadData(url) =>
      HttpRequest.getString(url).then((String value) {
        return JSON.decode(value);
      }).catchError((Object o) => print(o));
}

