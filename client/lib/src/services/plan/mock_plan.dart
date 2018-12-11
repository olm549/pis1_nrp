import 'package:angular/angular.dart';
import 'package:client/src/models/project_requirement.dart';

import '../../models/client.dart';
import '../../models/requirement.dart';

import './plan_service.dart';

@Injectable()
class MockPlan extends PlanService {
  static final requirements = <Requirement>[
     Requirement(1, 'R001', 'Func1', 'Requisito para proyecto de la asignatura'),
    Requirement(2, 'R002', 'Func2', 'Requisito 2 test'),
  ];

  Future<List<Requirement>> getRequirements() async {
    return requirements;
  }

  Future<List<ProjectRequirement>> getProjectRequirements() {
    // TODO: implement getProjectRequirements
    return null;
  }

  
}