import 'dart:async';

import '../../models/project_client.dart';

abstract class ProjectClientsService {
  Future<List<ProjectClient>> getProjectClients();

  Future<ProjectClient> updateProjectClient(int clientID, double weight);

  Future<bool> deleteProjectClient(int clientID);
}
