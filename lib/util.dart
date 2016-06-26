import 'dart:async';
import 'package:observe/observe.dart';

class Util {
    static Stream filterChangeStreamByProp(Stream propStream, List<Symbol> propNames) =>
    propStream
        .map((List<ChangeRecord> changes) =>
          changes.lastWhere((ChangeRecord c) =>
            c.runtimeType == PropertyChangeRecord
              && propNames.contains((c as PropertyChangeRecord).name))
        ).handleError((error) {}, test: (e) => e.runtimeType == StateError);
}