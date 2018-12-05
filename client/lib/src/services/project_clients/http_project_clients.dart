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

  Future<List<ProjectClient>> getProjectClients() async {}

  Future<ProjectClient> updateProjectClient(
      int clientID, double weight) async {}

  Future<bool> deleteProjectClient(int clientID) async {}
}
