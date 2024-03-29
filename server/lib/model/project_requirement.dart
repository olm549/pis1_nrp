import '../server.dart';

import './project.dart';
import './requirement.dart';

class ProjectRequirement extends ManagedObject<_ProjectRequirement>
    implements _ProjectRequirement {}

class _ProjectRequirement {
  @primaryKey
  int id;

  @Column(defaultValue: '0.0')
  double estimatedEffort;

  @Column(defaultValue: '0.0')
  double satisfaction;

  @Relate(#requirements, onDelete: DeleteRule.cascade)
  Project project;

  @Relate(#projects, onDelete: DeleteRule.cascade)
  Requirement requirement;
}
