import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:angular/angular.dart';

import '../../models/project.dart';
import '../../models/project_requirement.dart';

import '../user/user_service.dart';
import '../http_service.dart';

import './plan_service.dart';

@Injectable()
class HttpPlan extends PlanService {
  final HttpService _httpService;
  final UserService _userService;

  HttpPlan(this._httpService, this._userService);

  Project getActiveProject() {
    return _userService.getActiveProject();
  }

  Future<List<ProjectRequirement>> getPlan() async {
    try {
      final response = await _httpService.getClient().post(
        '${_httpService.getUrl()}/projects/${_userService.getActiveProject().id}/plan',
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${_userService.getAccessToken()}',
        },
      );

      if (response.statusCode == 200) {
        final projectRequirements = (_httpService.extractData(response) as List)
            .map((value) => ProjectRequirement.fromJson(value))
            .toList();

        return projectRequirements;
      } else {
        return [];
      }
    } catch (e) {
      _httpService.handleError(e);
    }
  }
}
