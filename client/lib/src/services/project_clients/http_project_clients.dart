import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:angular/angular.dart';

import '../../models/project_client.dart';

import '../user/user_service.dart';
import '../http_service.dart';

import './project_clients_service.dart';

@Injectable()
class HttpProjectClients extends ProjectClientsService {
  final HttpService _httpService;
  final UserService _userService;

  HttpProjectClients(this._httpService, this._userService);

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

  Future<ProjectClient> updateProjectClient(int clientID, double weight) async {
    try {
      final response = await _httpService.getClient().put(
            '${_httpService.getUrl()}/projects/${_userService.getActiveProject().id}/clients/$clientID',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader:
                  'Bearer ${_userService.getAccessToken()}',
            },
            body: jsonEncode({
              'weight': weight,
            }),
          );

      if (response.statusCode == 200) {
        final updatedProjectClient =
            ProjectClient.fromJson(_httpService.extractData(response));

        return updatedProjectClient;
      } else {
        // 401 response.
        return null;
      }
    } catch (e) {
      _httpService.handleError(e);
    }
  }

  Future<bool> deleteProjectClient(int clientID) async {
    try {
      final response = await _httpService.getClient().delete(
        '${_httpService.getUrl()}/projects/${_userService.getActiveProject().id}/clients/$clientID',
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
