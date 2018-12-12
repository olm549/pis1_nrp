import 'package:angular/angular.dart';

import '../../models/project.dart';
import '../../models/project_requirement.dart';

import './plan_service.dart';

@Injectable()
class MockPlan extends PlanService {
  Project getActiveProject() {
    return null;
  }

  Future<List<ProjectRequirement>> getPlan() async {
    return [];
  }
}
