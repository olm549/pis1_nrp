import 'dart:async';

import 'package:angular/angular.dart';

import '../../models/client.dart';

import './clients_service.dart';

import '../../models/project.dart';

@Injectable()
class MockClients implements ClientsService {
  static final clients = <Client>[
    Client(1, 'C001', 'Cliente', '1'),
    Client(2, 'C002', 'Cliente', '2'),
    Client(3, 'C003', 'Cliente', '3'),
    Client(4, 'C004', 'Cliente', '4')
  ];

  static final clientProjects = <Project>[
    Project(1, 'P001', 'Hola', 'Adios', 3.0, false),
    Project(2, 'P002', 'PRIS2018', 'Proyecto de la asignatura', 5.0, false),
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

  Future<List<Project>> getClientProjects(int id) async {
    return clientProjects;
  }

  Future<bool> addClientToProject(int id) async {
    return true;
  }
}
