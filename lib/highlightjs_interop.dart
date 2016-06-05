@JS('hljs')
library highlighter;

import 'package:js/js.dart';
import 'package:angular2/core.dart';

//  void highlightBlock(ElementRef e) => print(e);
  @JS('highlightBlock')
  external void highlightBlock(dynamic element);
