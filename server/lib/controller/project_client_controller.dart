import '../model/project_client.dart';
import '../model/requirement_value.dart';

import '../nrp_server.dart';

class ProjectClientController extends ResourceController {
  ProjectClientController(this.context);

  ManagedContext context;

  @Operation.get('projectID')
  Future<Response> getAllProjectClients(
    @Bind.path('projectID') int projectID,
  ) async {
    final getAllProjectClientsQuery = Query<ProjectClient>(context)
      ..where((pc) => pc.project.id).equalTo(projectID)
      ..join(object: (pc) => pc.client);

    // TODO: Add pagination.

    final fetchedProjectClients = await getAllProjectClientsQuery.fetch();

    return Response.ok(fetchedProjectClients);
  }

  @Operation.get('projectID', 'clientID')
  Future<Response> getProjectClient(
    @Bind.path('projectID') int projectID,
    @Bind.path('clientID') int clientID,
  ) async {
    final getProjectClientQuery = Query<ProjectClient>(context)
      ..where((pc) => pc.project.id).equalTo(projectID)
      ..where((pc) => pc.client.id).equalTo(clientID)
      ..join(object: (pc) => pc.client);

    final fetchedProjectClient = await getProjectClientQuery.fetchOne();

    return Response.ok(fetchedProjectClient);
  }

  @Operation.post('projectID')
  Future<Response> addProjectClient(
    @Bind.path('projectID') int projectID,
    @Bind.body() ProjectClient newProjectClient,
  ) async {
    final addProjectClientQuery = Query<ProjectClient>(context)
      ..values = newProjectClient
      ..values.project.id = projectID;

    final insertedProjectClient = await addProjectClientQuery.insert();

    return Response.ok(insertedProjectClient);
  }

  @Operation.put('projectID', 'clientID')
  Future<Response> modifyProjectClient(
    @Bind.path('projectID') int projectID,
    @Bind.path('clientID') int clientID,
    @Bind.body() ProjectClient projectClient,
  ) async {
    final modifyProjectClientQuery = Query<ProjectClient>(context)
      ..where((pc) => pc.project.id).equalTo(projectID)
      ..where((pc) => pc.client.id).equalTo(clientID)
      ..values = projectClient;

    final updatedProjectClient = await modifyProjectClientQuery.updateOne();

    return Response.ok(updatedProjectClient);
  }

  @Operation.delete('projectID', 'clientID')
  Future<Response> deleteProjectClient(
    @Bind.path('projectID') int projectID,
    @Bind.path('clientID') int clientID,
  ) async {
    final Future<Response> response = context.transaction((transaction) async {
      final deleteProjectClientQuery = Query<ProjectClient>(transaction)
        ..where((pc) => pc.project.id).equalTo(projectID)
        ..where((pc) => pc.client.id).equalTo(clientID);

      final projectClientRowsDeleted = await deleteProjectClientQuery.delete();

      final deleteRequirementValuesQuery = Query<RequirementValue>(transaction)
        ..where((rv) => rv.project.id).equalTo(projectID)
        ..where((rv) => rv.client.id).equalTo(clientID);

      final requirementValuesRowsDeleted =
          await deleteRequirementValuesQuery.delete();

      return Response.ok({
        'projectClientRowsDeleted': projectClientRowsDeleted,
        'requirementValuesRowsDeleted': requirementValuesRowsDeleted,
      });
    });

    return response;
  }
}
