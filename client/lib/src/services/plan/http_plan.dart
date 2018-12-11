import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:angular/angular.dart';
import 'package:client/src/models/project_requirement.dart';
import 'package:client/src/models/project_client.dart';

import '../../models/requirement.dart';

import '../user/user_service.dart';
import '../http_service.dart';

import './plan_service.dart';

@Injectable()
class HttpPlan extends PlanService {
  final HttpService _httpService;
  final UserService _userService;

  HttpPlan(this._httpService, this._userService);

  Future<List<Requirement>> getRequirements() async {
    try {
      final response = await _httpService.getClient().get(
        '${_httpService.getUrl()}/requirements',
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${_userService.getAccessToken()}',
        },
      );

      if (response.statusCode == 200) {
        final requirements = (_httpService.extractData(response) as List)
            .map((value) => Requirement.fromJson(value))
            .toList();

        return requirements;
      } else {
        // 404 response.
        return [];
      }
    } catch (e) {
      _httpService.handleError(e);
    }
  }

  Future<List<ProjectRequirement>> getProjectRequirements() async {
    try {
      final response = await _httpService.getClient().get(
        '${_httpService.getUrl()}/projects/${_userService.getActiveProject().id}/requirements',
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
        // 404 response.
        return [];
      }
    } catch (e) {
      _httpService.handleError(e);
    }
  }

    Future<List<ProjectClient>> getProjectClients() async {
    try {
      final response = await _httpService.getClient().get(
        '${_httpService.getUrl()}/projects/${_userService.getActiveProject().id}/clients',
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${_userService.getAccessToken()}',
        },
      );

      if (response.statusCode == 200) {
        final projectClients = (_httpService.extractData(response) as List)
            .map((value) => ProjectClient.fromJson(value))
            .toList();

        return projectClients;
      } else {
        // 404 response.
        return [];
      }
    } catch (e) {
      _httpService.handleError(e);
    }
  }
}
