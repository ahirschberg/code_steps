import 'dart:mirrors';
import 'package:code_steps/step_action.dart' show StepActionType;
import 'package:jsonx/jsonx.dart' as jsonx;
import 'package:ace/ace.dart';

class EnumStringHelper<T> {
  T enumFromString(String value) {
    return (reflectType(T) as ClassMirror)
        .getField(#values)
        .reflectee
        .firstWhere((e) =>
            e.toString().split('.')[1].toUpperCase() == value.toUpperCase());
  }

  String stringFromEnum(T value) => value.toString().split('.')[1];
}

class LessonSerializer {
  static Function defaultStringify = (v) => v.toString();
  static Map stringifyMapData(Map m,
      {Function keysTransformer: null, Function valuesTransformer: null}) {
    keysTransformer ??= defaultStringify;
    valuesTransformer ??= defaultStringify;
    return new Map.fromIterables(
        m.keys.map(keysTransformer), m.values.map(valuesTransformer));
  }

  static String encode(var obj) {
    jsonx.objectToJsons[Point] =
        (Point p) => {'row': p.row, 'column': p.column};
    jsonx.objectToJsons[Range] = (Range r) => {'start': r.start, 'end': r.end};
    return jsonx.encode(obj);
  }

  static EnumStringHelper<StepActionType> _stepActionTypeSerializer =
      new EnumStringHelper<StepActionType>();
  static Function stepActionTypeSetTransformer = (Set<StepActionType> set) =>
      set
          .map((t) => _stepActionTypeSerializer.stringFromEnum(t).toLowerCase())
          .toList();
}
