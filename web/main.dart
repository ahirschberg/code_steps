// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/platform/browser.dart';

import 'package:Polymorph/app_component.dart';
import 'package:Polymorph/progression_service.dart';

main() {
  bootstrap(AppComponent, [ProgressionService]);
}
