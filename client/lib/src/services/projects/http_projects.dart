import 'dart:async';

import 'package:angular/angular.dart';

import '../../models/project.dart';

import '../user/user_service.dart';
import '../http_service.dart';

import './projects_service.dart';

@Injectable()
class HttpProjects implements ProjectsService {
  final HttpService _httpService;
  final UserService _userService;

  HttpProjects(this._httpService, this._userService);

  Future<List<Project>> getProjects() async {
    try {
      final response = await _httpService.getClient().get(
        '${_httpService.getUrl()}/projects',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_userService.getAccessToken()}',
        },
      );

      if (response.statusCode == 200) {
        final projects = _httpService
            .extractData(response)
            .map((value) => Project.fromJson(value))
            .toList();

        return projects;
      } else {
        return [];
      }
    } catch (e) {
      throw _httpService.handleError(e);
    }
  }

  Future<Project> createProject(
    String projectID,
    String name,
    String description,
  ) async {
    try {
      final response = await _httpService.getClient().post(
        '${_httpService.getUrl()}/projects',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_userService.getAccessToken()}',
        },
        body: {
          'projectID': projectID,
          'name': name,
          'description': description,
        },
      );

      if (response.statusCode == 200) {
        final createdProject =
            Project.fromJson(_httpService.extractData(response));

        return createdProject;
      } else {
        return null;
      }
    } catch (e) {
      throw _httpService.handleError(e);
    }
  }

  Future<Project> updateProject(
    int id,
    String projectID,
    String name,
    String description,
    double effortLimit,
    bool active,
  ) async {
    try {
      final response = await _httpService.getClient().put(
        '${_httpService.getUrl()}/projects/$id',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_userService.getAccessToken()}',
        },
        body: {
          'projectID': projectID,
          'name': name,
          'description': description,
          'effortLimit': effortLimit,
          'active': active,
        },
      );

      if (response.statusCode == 200) {
        final updatedProject =
            Project.fromJson(_httpService.extractData(response));

        return updatedProject;
      } else {
        return null;
      }
    } catch (e) {
      throw _httpService.handleError(e);
    }
  }

  Future<bool> deleteProject(int id) async {
    try {
      final response = await _httpService.getClient().delete(
        '${_httpService.getUrl()}/projects/$id',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_userService.getAccessToken()}',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw _httpService.handleError(e);
    }
  }

  Future<void> changeActiveProject(int id) {
    // TODO: Call server and change active project.

    return null;
  }
}
