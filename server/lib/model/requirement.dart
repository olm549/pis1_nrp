import '../nrp_server.dart';

import './project_requirement.dart';
import './requirement_value.dart';

class Requirement extends ManagedObject<_Requirement> implements _Requirement {}

class _Requirement {
  @primaryKey
  int id;

  @Column(unique: true, indexed: true)
  String requirementID;

  String title;

  String description;

  ManagedSet<ProjectRequirement> projects;

  ManagedSet<RequirementValue> values;
}
