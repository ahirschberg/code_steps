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

  static dynamic decode(String jsonData) {
    return jsonx.decode(jsonData, reviver: (var key, var val) {
      if (key == 'start' || key == 'end') {
        return new Point(val['row'], val['column']);
      } else if (key == 'range') {
        return new Range.fromPoints(val['start'], val['end']);
      } else if (key == 'stepData') {
        Map<int, List<String>> stringedActionTypes =
            val as Map<int, List<String>>;
        return new Map.fromIterables(
            stringedActionTypes.keys,
            stringedActionTypes.values.map((type_list) => type_list.map(
                (type_str) =>
                    _stepActionTypeSerializer.enumFromString(type_str))));
      }
      return val;
    });
  }
}
