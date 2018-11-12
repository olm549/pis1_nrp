import '../model/client.dart';
import '../model/project.dart';
import '../model/project_client.dart';
import '../model/project_requirement_client.dart';

import '../nrp_server.dart';

class ProjectClientController extends ResourceController {
  ManagedContext context;

  ProjectClientController(this.context);

  @Operation.get('projectID')
  Future<Response> getAllProjectClients(
    @Bind.path('projectID') int projectID,
  ) async {
    final getAllProjectClientsQuery = Query<ProjectClient>(context)
      ..join(object: (pc) => pc.client)
      ..where((pc) => pc.project.owner.id)
          .equalTo(request.authorization.ownerID)
      ..where((pc) => pc.client.owner.id).equalTo(request.authorization.ownerID)
      ..where((pc) => pc.project.id).equalTo(projectID);

    // TODO: Add pagination.

    return Response.ok(await getAllProjectClientsQuery.fetch());
  }

  @Operation.get('projectID', 'clientID')
  Future<Response> getProjectClient(
    @Bind.path('projectID') int projectID,
    @Bind.path('clientID') int clientID,
  ) async {
    final getProjectClientQuery = Query<ProjectClient>(context)
      ..join(object: (pc) => pc.client)
      ..where((pc) => pc.project.owner.id)
          .equalTo(request.authorization.ownerID)
      ..where((pc) => pc.client.owner.id).equalTo(request.authorization.ownerID)
      ..where((pc) => pc.project.id).equalTo(projectID)
      ..where((pc) => pc.client.id).equalTo(clientID);

    return Response.ok(await getProjectClientQuery.fetchOne());
  }

  @Operation.post('projectID')
  Future<Response> addProjectClient(
    @Bind.path('projectID') int projectID,
    @Bind.body() Map content,
  ) async {
    final getProjectQuery = Query<Project>(context)
      ..where((p) => p.owner.id).equalTo(request.authorization.ownerID)
      ..where((p) => p.id).equalTo(projectID);

    final getClientQuery = Query<Client>(context)
      ..where((c) => c.owner.id).equalTo(request.authorization.ownerID)
      ..where((c) => c.id)
          .equalTo(int.tryParse(content['clientID'].toString()));

    final project = await getProjectQuery.fetchOne();
    final client = await getClientQuery.fetchOne();

    final addProjectClientQuery = Query<ProjectClient>(context)
      ..values.project = project
      ..values.client = client
      ..values.weight = double.tryParse(content['weight'].toString());

    return Response.ok(await addProjectClientQuery.insert());
  }

  @Operation.put('projectID', 'clientID')
  Future<Response> modifyProjectClient(
    @Bind.path('projectID') int projectID,
    @Bind.path('clientID') int clientID,
    @Bind.body() ProjectClient projectClient,
  ) async {
    final modifyProjectClientQuery = Query<ProjectClient>(context)
      ..where((pc) => pc.project.owner.id)
          .equalTo(request.authorization.ownerID)
      ..where((pc) => pc.client.owner.id).equalTo(request.authorization.ownerID)
      ..where((pc) => pc.project.id).equalTo(projectID)
      ..where((pc) => pc.client.id).equalTo(clientID)
      ..values = projectClient;

    return Response.ok(await modifyProjectClientQuery.updateOne());
  }

  @Operation.delete('projectID', 'clientID')
  Future<Response> deleteProjectClient(
    @Bind.path('projectID') int projectID,
    @Bind.path('clientID') int clientID,
  ) async {
    final response = await context.transaction((transaction) async {
      final deleteProjectClientQuery = Query<ProjectClient>(transaction)
        ..where((pc) => pc.project.owner.id)
            .equalTo(request.authorization.ownerID)
        ..where((pc) => pc.client.owner.id)
            .equalTo(request.authorization.ownerID)
        ..where((pc) => pc.project.id).equalTo(projectID)
        ..where((pc) => pc.client.id).equalTo(clientID);

      await deleteProjectClientQuery.delete();

      final deleteRequirementValuesQuery =
          Query<ProjectRequirementClient>(transaction)
            ..where((prc) => prc.project.id).equalTo(projectID)
            ..where((prc) => prc.client.id).equalTo(clientID);

      await deleteRequirementValuesQuery.delete();
    });

    return Response.ok(response);

    /*
    final deleteProjectClientQuery = Query<ProjectClient>(context)
      ..where((pc) => pc.project.owner.id)
          .equalTo(request.authorization.ownerID)
      ..where((pc) => pc.client.owner.id).equalTo(request.authorization.ownerID)
      ..where((pc) => pc.project.id).equalTo(projectID)
      ..where((pc) => pc.client.id).equalTo(clientID);

    return Response.ok(await deleteProjectClientQuery.delete());
    */
  }
}
