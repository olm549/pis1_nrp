import 'dart:async';

import '../../models/project_requirement.dart';

abstract class ProjectRequirementService {
  Future<List<ProjectRequirement>> getProjectRequirements();

  Future<ProjectRequirement> updateProjectRequirement(
    int requirementID,
    double estimatedEffort,
    double satisfaction,
  );

  Future<bool> deleteProjectRequirement(int requirementID);
}
