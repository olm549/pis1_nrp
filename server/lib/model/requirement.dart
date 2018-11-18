import '../nrp_server.dart';

import './project_requirement.dart';
import './requirement_value.dart';
import './user.dart';

class Requirement extends ManagedObject<_Requirement> implements _Requirement {}

class _Requirement {
  @primaryKey
  int id;

  @Column(indexed: true)
  String requirementID;

  String title;

  String description;

  @Relate(#requirements, onDelete: DeleteRule.cascade)
  User owner;

  ManagedSet<ProjectRequirement> projects;

  ManagedSet<RequirementValue> values;
}
