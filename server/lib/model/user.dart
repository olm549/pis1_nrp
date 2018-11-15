import '../nrp_server.dart';

import './client.dart';
import './project.dart';
import './requirement.dart';

class User extends ManagedObject<_User>
    implements _User, ManagedAuthResourceOwner<_User> {
  @Serialize(input: true, output: false)
  String password;
}

class _User {
  /*
  @primaryKey
  int id;

  @Column(unique: true, indexed: true)
  String username;

  @Column(omitByDefault: true)
  String hashedPassword;

  @Column(omitByDefault: true)
  String salt;

  ManagedSet<ManagedAuthToken> tokens;
  */

  ManagedSet<Project> projects;

  ManagedSet<Requirement> requirements;

  ManagedSet<Client> clients;
}