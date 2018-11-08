import '../nrp_server.dart';

import './project_requirement.dart';
import './project_requirement_client.dart';

class Requirement extends ManagedObject<_Requirement> implements _Requirement {}

class _Requirement {
  @primaryKey
  int id;

  @Column(indexed: true)
  String requirementID;

  String title;

  String description;

  ManagedSet<ProjectRequirement> projects;

  ManagedSet<ProjectRequirementClient> values;
}
