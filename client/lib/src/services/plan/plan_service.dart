import 'dart:async';

import 'package:client/src/models/project_requirement.dart';

import '../../models/requirement.dart';

abstract class PlanService {
  Future<List<Requirement>> getRequirements();

  Future<List<ProjectRequirement>> getProjectRequirements();

}
