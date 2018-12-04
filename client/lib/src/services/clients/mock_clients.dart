import 'dart:async';

import 'package:angular/angular.dart';

import '../../models/client.dart';

import './clients_service.dart';

import '../../models/project.dart';
import '../../models/project_client.dart';

@Injectable()
class MockClients implements ClientsService {
  static final clients = <Client>[
    Client(1, 'C001', 'Cliente', '1'),
    Client(2, 'C002', 'Cliente', '2'),
    Client(3, 'C003', 'Cliente', '3'),
    Client(4, 'C004', 'Cliente', '4')
  ];

  final activeClients = <ProjectClient>[
    ProjectClient(1, 0.4, clients[0]),
    ProjectClient(2, 2.0, clients[1]),
  ];

  final projectsInClient = <Project>[
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

  Future<List<ProjectClient>> getProjectClients() async {
    return activeClients;
  }

  Future<bool> addClientToProject(Client client) async {
    return true;
  }
  Future<bool> addToActiveProject(Client client) async {
    return true;
  }

  List<Project> getProjectsFromClients(Client client) {
    return projectsInClient;
  }

  Future<bool> updateWeightClient(int id, double weight) async{
     return Future.sync(() => true);
  }

  Future<bool> deleteActiveClient(int id) async {
    return Future.sync(() => true);
  }
}
