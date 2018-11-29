import 'dart:async';

import '../../models/project_requirement.dart';

import '../../models/requirement.dart';
import '../../models/project.dart';

abstract class RequirementsService {
  Future<List<Requirement>> getRequirements();

  Future<Requirement> createRequirement(
    String requirementID,
    String title,
    String description,
  );

  Future<Requirement> updateRequirement(
    int id,
    String requirementID,
    String title,
    String description,
  );

  Future<bool> deleteRequirement(int id);

  Future<List<ProjectRequirement>> getProjectRequirements();
  Future<bool> addRequirementToProject(ProjectRequirement requirement);
  Future<bool> deleteActiveRequirement(int id);
  List<Project> getProjectsFromRequirement(Requirement requirement);
  Future<bool> updateEffortClient(int id, double effort);
}
