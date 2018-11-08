import '../nrp_server.dart';

import './client.dart';
import './project.dart';
import './requirement.dart';

class ProjectRequirementClient extends ManagedObject<_ProjectRequirementClient>
    implements _ProjectRequirementClient {}

class _ProjectRequirementClient {
  @primaryKey
  int id;

  double value;

  @Relate(#values, onDelete: DeleteRule.cascade)
  Project project;

  @Relate(#values, onDelete: DeleteRule.cascade)
  Requirement requirement;

  @Relate(#values, onDelete: DeleteRule.cascade)
  Client client;
}
