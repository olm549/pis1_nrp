import '../nrp_server.dart';

import './client.dart';
import './project.dart';

class ProjectClient extends ManagedObject<_ProjectClient>
    implements _ProjectClient {}

class _ProjectClient {
  @primaryKey
  int id;

  @Column(defaultValue: '0.0')
  double weight;

  @Relate(#clients, onDelete: DeleteRule.cascade)
  Project project;

  @Relate(#projects, onDelete: DeleteRule.cascade)
  Client client;
}
