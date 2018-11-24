import './client.dart';

class ProjectClient {
  int id;
  double weight;
  Client client;

  ProjectClient(this.id, this.weight, this.client);

  factory ProjectClient.fromJson(Map<String, dynamic> projectClient) {
    return ProjectClient(
      projectClient['id'],
      projectClient['weight'],
      Client.fromJson(projectClient[
          'client']), // TODO: Check nullability of client's values.
    );
  }

  Map toJson() {
    return {
      'id': id,
      'weight': weight,
    };
  }
}
