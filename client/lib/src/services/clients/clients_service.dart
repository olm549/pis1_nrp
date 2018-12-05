import 'dart:async';

import '../../models/client.dart';
import '../../models/project.dart';
import '../../models/project_client.dart';

abstract class ClientsService {
  Future<List<Client>> getClients();

  Future<Client> createClient(String clientID, String name, String surname);

  Future<Client> updateClient(
    int id,
    String clientID,
    String name,
    String surname,
  );

  Future<bool> deleteClient(int id);

  Future<List<ProjectClient>> getProjectClients();
  Future<bool> addClientToProject(Client client);
  Future<bool> addToActiveProject(Client client);
  List<Project> getProjectsFromClients(Client client);

  Future<bool> updateWeightClient(int id, double weightToAdd);
  Future<bool> deleteActiveClient(int id);
}
