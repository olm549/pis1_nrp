import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:angular/angular.dart';

import '../../models/project.dart';
import '../../models/requirement.dart';

import '../user/user_service.dart';
import '../http_service.dart';

import './requirements_service.dart';

@Injectable()
class HttpRequirements implements RequirementsService {
  final HttpService _httpService;
  final UserService _userService;

  HttpRequirements(this._httpService, this._userService);

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

  Future<List<Project>> getRequirementProjects(int id) async {}

  Future<Requirement> createRequirement(
    String requirementID,
    String title,
    String description,
  ) async {
    try {
      final response = await _httpService.getClient().post(
            '${_httpService.getUrl()}/requirements',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader:
                  'Bearer ${_userService.getAccessToken()}',
            },
            body: jsonEncode({
              'requirementID': requirementID,
              'title': title,
              'description': description,
            }),
          );

      if (response.statusCode == 200) {
        final createdRequirement =
            Requirement.fromJson(_httpService.extractData(response));

        return createdRequirement;
      } else {
        return null;
      }
    } catch (e) {
      _httpService.handleError(e);
    }
  }

  Future<Requirement> updateRequirement(
    int id,
    String requirementID,
    String title,
    String description,
  ) async {
    try {
      final response = await _httpService.getClient().put(
            '${_httpService.getUrl()}/requirements/$id',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader:
                  'Bearer ${_userService.getAccessToken()}',
            },
            body: jsonEncode({
              'requirementID': requirementID,
              'title': title,
              'description': description,
            }),
          );

      if (response.statusCode == 200) {
        final updatedRequirement =
            Requirement.fromJson(_httpService.extractData(response));

        return updatedRequirement;
      } else {
        // 401 response.
        return null;
      }
    } catch (e) {
      throw _httpService.handleError(e);
    }
  }

  Future<bool> deleteRequirement(int id) async {
    try {
      final response = await _httpService.getClient().delete(
        '${_httpService.getUrl()}/requirements/$id',
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
      throw _httpService.handleError(e);
    }
  }

  Future<bool> addRequirementToProject(int id) async {}
}
