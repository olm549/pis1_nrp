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

  Future<ProjectRequirement> updateProjectRequirement(
    int requirementID,
    double estimatedEffort,
  ) async {
    try {
      final response = await _httpService.getClient().put(
            '${_httpService.getUrl()}/projects/${_userService.getActiveProject().id}/requirements/$requirementID',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader:
                  'Bearer ${_userService.getAccessToken()}',
            },
            body: jsonEncode({
              'estimatedEffort': estimatedEffort,
            }),
          );

      if (response.statusCode == 200) {
        final updatedProjectRequirement =
            ProjectRequirement.fromJson(_httpService.extractData(response));

        return updatedProjectRequirement;
      } else {
        // 401 response.
        return null;
      }
    } catch (e) {
      _httpService.handleError(e);
    }
  }

  Future<bool> deleteProjectRequirement(int requirementID) async {
    try {
      final response = await _httpService.getClient().delete(
        '${_httpService.getUrl()}/projects/${_userService.getActiveProject().id}/requirements/$requirementID',
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${_userService.getAccessToken()}',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        // 401 response.
        return false;
      }
    } catch (e) {
      _httpService.handleError(e);
    }
  }
}
