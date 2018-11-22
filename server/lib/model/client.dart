import '../nrp_server.dart';

import './project_client.dart';
import './requirement_value.dart';

class Client extends ManagedObject<_Client> implements _Client {}

class _Client {
  @primaryKey
  int id;

  @Column(unique: true, indexed: true)
  String clientID;

  String name;

  String surname;

  ManagedSet<ProjectClient> projects;

  ManagedSet<RequirementValue> values;
}
