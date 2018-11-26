import 'dart:async';

import '../../models/client.dart';
import '../../models/project.dart';

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

  Future<List<Client>> getActiveClients(Project currentProject);
  Future<bool> addClientToProject(Client client, Project project);
}
