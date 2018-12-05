import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:angular/angular.dart';

import '../../models/project_requirement.dart';

import '../user/user_service.dart';
import '../http_service.dart';

import './project_requirements_service.dart';

@Injectable()
class HttpProjectRequirements extends ProjectRequirementService {
  final HttpService _httpService;
  final UserService _userService;

  HttpProjectRequirements(this._httpService, this._userService);

  Future<List<ProjectRequirement>> getProjectRequirements() async {}

  Future<ProjectRequirement> updateProjectRequirement(
    int requirementID,
    double estimatedEffort,
    double satisfaction,
  ) async {}

  Future<bool> deleteProjectRequirement(int requirementID) async {}
}
