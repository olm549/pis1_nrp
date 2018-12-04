import '../server.dart';

import './client.dart';
import './project.dart';
import './requirement.dart';

class RequirementValue extends ManagedObject<_RequirementValue>
    implements _RequirementValue {}

class _RequirementValue {
  @primaryKey
  int id;

  @Column(defaultValue: '0.0')
  double value;

  @Relate(#values, onDelete: DeleteRule.cascade)
  Project project;

  @Relate(#values, onDelete: DeleteRule.cascade)
  Requirement requirement;

  @Relate(#values, onDelete: DeleteRule.cascade)
  Client client;
}
