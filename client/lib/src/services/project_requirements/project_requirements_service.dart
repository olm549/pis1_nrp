import 'dart:async';

import '../../models/project_requirement.dart';

abstract class ProjectRequirementsService {
  Future<List<ProjectRequirement>> getProjectRequirements();

  Future<ProjectRequirement> updateProjectRequirement(
    int requirementID,
    double estimatedEffort,
  );

  Future<bool> deleteProjectRequirement(int requirementID);
}
