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
    Project(
      id: 1,
      projectID: 'P001',
      name: 'Hola',
      description: 'Adios',
      effortLimit: 3.0,
      active: false,
    ),
    Project(
      id: 2,
      projectID: 'P002',
      name: 'PRIS2018',
      description: 'Proyecto de la asignatura',
      effortLimit: 5.0,
      active: false,
    ),
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
