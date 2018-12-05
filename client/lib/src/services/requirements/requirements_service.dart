import 'dart:async';

import '../../models/project_requirement.dart';

import '../../models/requirement.dart';
import '../../models/project.dart';

abstract class RequirementsService {
  Future<List<Requirement>> getRequirements();

  Future<List<Project>> getRequirementProjects(int id);

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

  Future<bool> addRequirementToProject(int id);
}
