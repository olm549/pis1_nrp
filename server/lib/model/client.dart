import '../nrp_server.dart';

import './project_client.dart';
import './project_requirement_client.dart';
import './user.dart';

class Client extends ManagedObject<_Client> implements _Client {}

class _Client {
  @primaryKey
  int id;

  @Column(indexed: true)
  String clientID;

  String name;

  String surname;

  @Relate(#clients, onDelete: DeleteRule.cascade)
  User owner;

  ManagedSet<ProjectClient> projects;

  ManagedSet<ProjectRequirementClient> values;
}
