// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2/platform/browser.dart';

import 'package:angular2/platform/common.dart';
import 'package:angular2/router.dart';
import 'package:code_steps/app_component.dart';
import 'package:code_steps/lesson_io.dart';
import 'package:code_steps/step_context_service_provider.dart';
import 'package:code_steps/action/step_actions_provider.dart';

main() {
  bootstrap(AppComponent, [
    LessonIO,
    StepActionsProvider,
    stepContextServiceProvider,
    ROUTER_PROVIDERS,
    provide(LocationStrategy, useClass: HashLocationStrategy)
  ]);
}
