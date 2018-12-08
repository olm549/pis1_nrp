import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:angular/angular.dart';

import '../../models/client.dart';
import '../../models/project.dart';

import '../user/user_service.dart';
import '../http_service.dart';

import './clients_service.dart';

@Injectable()
class HttpClients extends ClientsService {
  final HttpService _httpService;
  final UserService _userService;

  HttpClients(this._httpService, this._userService);

  Future<List<Client>> getClients() async {
    try {
      final response = await _httpService.getClient().get(
        '${_httpService.getUrl()}/clients',
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${_userService.getAccessToken()}',
        },
      );

      if (response.statusCode == 200) {
        final clients = (_httpService.extractData(response) as List)
            .map((value) => Client.fromJson(value))
            .toList();

        return clients;
      } else {
        // 404 response.
        return [];
      }
    } catch (e) {
      _httpService.handleError(e);
    }
  }

  Future<Client> createClient(
    String clientID,
    String name,
    String surname,
  ) async {
    try {
      final response = await _httpService.getClient().post(
            '${_httpService.getUrl()}/clients',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader:
                  'Bearer ${_userService.getAccessToken()}',
            },
            body: jsonEncode({
              'clientID': clientID,
              'name': name,
              'surname': surname,
            }),
          );

      if (response.statusCode == 200) {
        final createdClient =
            Client.fromJson(_httpService.extractData(response));

        return createdClient;
      } else {
        return null;
      }
    } catch (e) {
      _httpService.handleError(e);
    }
  }

  Future<Client> updateClient(
    int id,
    String clientID,
    String name,
    String surname,
  ) async {
    try {
      final response = await _httpService.getClient().put(
            '${_httpService.getUrl()}/clients/$id',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader:
                  'Bearer ${_userService.getAccessToken()}',
            },
            body: jsonEncode({
              'clientID': clientID,
              'name': name,
              'surname': surname,
            }),
          );

      if (response.statusCode == 200) {
        final updatedClient =
            Client.fromJson(_httpService.extractData(response));

        return updatedClient;
      } else {
        // 401 response.
        return null;
      }
    } catch (e) {
      throw _httpService.handleError(e);
    }
  }

  Future<bool> deleteClient(int id) async {
    try {
      final response = await _httpService.getClient().delete(
        '${_httpService.getUrl()}/clients/$id',
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

  Future<List<Project>> getClientProjects(int id) async {
    try {
      final response = await _httpService.getClient().get(
        '${_httpService.getUrl()}/clients/$id',
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${_userService.getAccessToken()}',
        },
      );

      if (response.statusCode == 200) {
        final projects = _httpService
            .extractData(response)['projects']
            .map((value) => Project.fromJson(value['project']))
            .toList();

        return projects;
      } else {
        return [];
      }
    } catch (e) {
      _httpService.handleError(e);
    }
  }

  Future<bool> addClientToProject(int id) async {
    try {
      final response = await _httpService.getClient().post(
            '${_httpService.getUrl()}/projects/${_userService.getActiveProject().id}/clients',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader:
                  'Bearer ${_userService.getAccessToken()}',
            },
            body: jsonEncode({
              'client': {
                'id': id,
              },
            }),
          );
          
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      _httpService.handleError(e);
    }
  }
}
