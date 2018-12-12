import 'package:angular/angular.dart';

import '../../models/project.dart';

import './plan_service.dart';

@Injectable()
class MockPlan extends PlanService {
  Project getActiveProject() {
    return null;
  }
}
