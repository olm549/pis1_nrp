import 'dart:async';

import 'package:angular/angular.dart';

import '../../models/requirement.dart';
import '../../models/project.dart';

import './requirements_service.dart';

@Injectable()
class MockRequirements implements RequirementsService {
  final requirements = <Requirement>[
    Requirement(1, 'R001', 'Func1', 'Requisito'),
    Requirement(2, 'R002', 'Func1', 'Requisito para proyecto de la asignatura'),
    Requirement(3, 'R003', 'Func1', 'Sin descripción'),
    Requirement(4, 'R004', 'Func2', 'NRP')
  ];

  Future<List<Requirement>> getRequirements() async {
    return requirements;
  }

  Future<Requirement> createRequirement(
    String requirementID,
    String title,
    String description,
  ) async {
    return Requirement(20, requirementID, title, description);
  }

  Future<Requirement> updateRequirement(
    int id,
    String requirementID,
    String title,
    String description,
  ) async {
    return Requirement(id, requirementID, title, description);
  }

  Future<bool> deleteRequirement(int id) async {
    return Future.sync(() => true);
  }

  Future<List<Requirement>> getActiveRequirements(Project currentProject) async{
    return requirements;
  }

  Future<bool> addRequirementToProject(Requirement requirement, Project project) async{
    return true;
  }
}
