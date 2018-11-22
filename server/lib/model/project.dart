import '../nrp_server.dart';

import './project_client.dart';
import './project_requirement.dart';
import './requirement_value.dart';
import './user.dart';

class Project extends ManagedObject<_Project> implements _Project {}

class _Project {
  @primaryKey
  int id;

  @Column(unique: true, indexed: true)
  String projectID;

  String name;

  String description;

  @Column(defaultValue: '0.0')
  double effortLimit;

  @Column(defaultValue: 'false')
  bool active;

  @Relate(#projects, onDelete: DeleteRule.cascade)
  User owner;

  ManagedSet<ProjectRequirement> requirements;

  ManagedSet<ProjectClient> clients;

  ManagedSet<RequirementValue> values;
}
