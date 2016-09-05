library lesson_serializer;

import 'package:code_steps/action/action_region.dart';
import 'package:code_steps/action/step_action.dart' show StepActionType;

import 'package:jsonx/jsonx.dart' as jsonx;
import 'package:ace/ace.dart';

@MirrorsUsed(targets: 'step_action.StepActionType.values')
import 'dart:mirrors';


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
  static final Function identity = (v) => v;
  static final Function stringify = (v) => v.toString();
  static final Function destringifyInt = (String s) => int.parse(s);
  static Map transformMap(Map m, {Function key: null, Function value: null}) {
    key ??= stringify; // json keys must be strings.
    value ??= identity;
    return new Map.fromIterables(m.keys.map(key), m.values.map(value));
  }

  static final EnumStringHelper<StepActionType> stepActionTypeHelper =
      new EnumStringHelper<StepActionType>();

  static String encode(var obj) {
    jsonx.objectToJsons[Point] =
        (Point p) => {'row': p.row, 'column': p.column};
    jsonx.objectToJsons[Range] = (Range r) => {'start': r.start, 'end': r.end};
    return jsonx.encode(obj);
  }

  static Function stepActionTypeTransformer = (StepActionType t) =>
      stepActionTypeHelper.stringFromEnum(t).toLowerCase();

  static dynamic decode(String jsonData) {
    return jsonx.decode(jsonData, reviver: (var key, var val) {
      if (key == 'start' || key == 'end') {
        return new Point(val['row'], val['column']);
      } else if (key == 'range') {
        return new Range.fromPoints(val['start'], val['end']);
      } else if (key == 'step_data') {
        Map<int, List<String>> stringedActionTypes =
            val as Map<int, List<String>>;
        return new Map.fromIterables(
            stringedActionTypes.keys.map(destringifyInt),
            stringedActionTypes.values.map((type_list) => type_list.map(
                (type_str) =>
                    stepActionTypeHelper.enumFromString(type_str)).toSet()));
      } else if (key == 'regions') {
        return val.map((region_map) => new ActionRegion(region_map['range'], region_map['step_data'])).toList();
      }
      return val;
    });
  }
}
