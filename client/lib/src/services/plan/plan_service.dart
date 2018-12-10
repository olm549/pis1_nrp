import 'dart:async';

import '../../models/requirement.dart';

abstract class PlanService {
  Future<List<Requirement>> getRequirements();

}
