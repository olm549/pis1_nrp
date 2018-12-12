import 'dart:async';

import '../../models/project.dart';
import '../../models/project_requirement.dart';

abstract class PlanService {
  Project getActiveProject();

  Future<List<ProjectRequirement>> getPlan();
}
