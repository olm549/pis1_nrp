import 'dart:async';

import 'package:angular/angular.dart';

import '../model/requirement.dart';

@Injectable()
class RequirementsService {
  Future<List<Requirement>> getRequirements() async => null;

  Future<Requirement> createRequirement(String requirementId, String requirementTitle, String requirementDescription) async => null;
}
