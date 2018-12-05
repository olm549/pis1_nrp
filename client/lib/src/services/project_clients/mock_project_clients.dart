import 'package:angular/angular.dart';

import '../../models/client.dart';
import '../../models/project_client.dart';

import './project_clients_service.dart';

@Injectable()
class MockProjectClients extends ProjectClientsService {
  static final projectClients = <ProjectClient>[
    ProjectClient(1, 10.0, Client(1, 'C001', 'Cliente', '1')),
    ProjectClient(2, 20.0, Client(2, 'C002', 'Cliente', '2')),
  ];

  Future<List<ProjectClient>> getProjectClients() async {
    return projectClients;
  }

  Future<ProjectClient> updateProjectClient(
    int clientID,
    double weight,
  ) async {
    return null;
  }

  Future<bool> deleteProjectClient(int clientID) async {
    return true;
  }
}
