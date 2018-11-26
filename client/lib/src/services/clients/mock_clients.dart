import 'dart:async';

import 'package:angular/angular.dart';

import '../../models/client.dart';

import './clients_service.dart';

import '../../models/project.dart';

@Injectable()
class MockClients implements ClientsService {
  final clients = <Client>[
    Client(1, 'C001', 'Cliente', '1'),
    Client(2, 'C002', 'Cliente', '2'),
    Client(3, 'C003', 'Cliente', '3'),
    Client(4, 'C004', 'Cliente', '4')
  ];

  Future<List<Client>> getClients() async {
    return clients;
  }

  Future<Client> createClient(
    String clientID,
    String name,
    String surname,
  ) async {
    return Client(20, clientID, name, surname);
  }

  Future<Client> updateClient(
    int id,
    String clientID,
    String name,
    String surname,
  ) async {
    return Client(id, clientID, name, surname);
  }

  Future<bool> deleteClient(int id) async {
    return Future.sync(() => true);
  }

  Future<List<Client>> getActiveClients(Project currentProject) async {
    return clients;
  }
  Future<bool> addClientToProject(Client client, Project project) async {
    return true;
  }
}
