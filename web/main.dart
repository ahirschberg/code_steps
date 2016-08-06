// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/platform/browser.dart';

import 'package:code_steps/app_component.dart';
import 'package:code_steps/lesson_loader.dart';
import 'package:code_steps/step_context_service_provider.dart';
import 'package:code_steps/step_action.dart';
import 'package:code_steps/step_actions_provider.dart';

main() {
  bootstrap(AppComponent, [LessonLoader, StepActionsProvider, stepContextServiceProvider]);
}
