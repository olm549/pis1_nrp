import './client.dart';

class ProjectClient {
  int id;
  double weight;
  Client client;

  ProjectClient(this.id, this.weight, this.client);

  factory ProjectClient.fromJson(Map<String, dynamic> projectClient) {
    return ProjectClient(
      projectClient.containsKey('id') ? projectClient['id'] : null,
      projectClient.containsKey('weight') ? projectClient['weight'] : null,
      projectClient.containsKey('client')
          ? Client.fromJson(projectClient['client'])
          : null,
    );
  }

  Map toJson() {
    return {
      'id': id,
      'weight': weight,
      'client': client.toJson(),
    };
  }
}
