import 'package:angular/angular.dart';

import '../../models/project_requirement.dart';
import '../../models/requirement.dart';

import './project_requirements_service.dart';

@Injectable()
class MockProjectRequirements extends ProjectRequirementService {
  static final projectRequirements = <ProjectRequirement>[
    ProjectRequirement(
      1,
      0.2,
      0.4,
      Requirement(1, 'R001', 'Func1', 'Requisito'),
    ),
    ProjectRequirement(
      2,
      7.2,
      8.9,
      Requirement(
          2, 'R002', 'Func1', 'Requisito para proyecto de la asignatura'),
    ),
  ];

  Future<List<ProjectRequirement>> getProjectRequirements() async {
    return projectRequirements;
  }

  Future<ProjectRequirement> updateProjectRequirement(
    int requirementID,
    double estimatedEffort,
  ) async {
    return null;
  }

  Future<bool> deleteProjectRequirement(int requirementID) async {
    return true;
  }
}
