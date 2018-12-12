import 'dart:async';

import '../../models/project.dart';

import '../../models/requirement.dart';

abstract class PlanService {
  Project getActiveProject();
}
