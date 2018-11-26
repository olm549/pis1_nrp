import 'dart:async';

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

  Future<List<Requirement>> getActiveRequirements(Project currentProject);
  Future<bool> addRequirementToProject(Requirement requirement, Project project);
}
