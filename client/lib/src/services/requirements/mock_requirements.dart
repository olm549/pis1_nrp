import 'dart:async';

import 'package:angular/angular.dart';

import '../../models/requirement.dart';
import '../../models/project.dart';
import '../../models/project_requirement.dart';
import './requirements_service.dart';

@Injectable()
class MockRequirements implements RequirementsService {
  static final requirements = <Requirement>[
    Requirement(1, 'R001', 'Func1', 'Requisito'),
    Requirement(2, 'R002', 'Func1', 'Requisito para proyecto de la asignatura'),
    Requirement(3, 'R003', 'Func1', 'Sin descripción'),
    Requirement(4, 'R004', 'Func2', 'NRP')
  ];

  final activeRequirements = <ProjectRequirement>[
    ProjectRequirement(1, 0.2, 0.4, requirements[0]),
    ProjectRequirement(2, 7.2, 8.9, requirements[3]),
  ];

  final projectsInRequirement = <Project>[
    Project(1, 'P001', 'Hola', 'Adios', 3.0, false),
    Project(2, 'P002', 'PRIS2018', 'Proyecto de la asignatura', 5.0, false),
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

  Future<List<ProjectRequirement>> getProjectRequirements() async{
    return activeRequirements;
  }

  Future<bool> addRequirementToProject(ProjectRequirement requirement) async{
    return true;
  }

  Future<bool> deleteActiveRequirement(int id) async {
    return Future.sync(() => true);
  }

  List<Project> getProjectsFromRequirement(Requirement requirement) {
    return projectsInRequirement;
  }

  Future<bool> updateEffortClient(int id, double effort){
    return Future.sync(() => true);
  }
}
