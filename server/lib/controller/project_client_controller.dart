import '../model/project_client.dart';
import '../model/requirement_value.dart';

import '../nrp_server.dart';

/// A controller that handles requests for the [ProjectClient] resources.
class ProjectClientController extends ResourceController {
  ProjectClientController(this.context);

  ManagedContext context;

  /// Fetches all client's data for a project.
  ///
  /// A list of [ProjectClient] resources joined with the client's data
  /// is returned in the body of a 200 response.
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

  /// Fetches a certain client's data for a project.
  ///
  /// The [ProjectClient.id] isn't used to fetch the resource. Instead,
  /// both [ProjectClient.project.id] and [ProjectClient.client.id] are
  /// taken from the request's path.
  ///
  /// Returns a 200 response with the [ProjectClient] resource and the
  /// client's data.
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

  /// Inserts a new project client.
  ///
  /// Values of the new resource, including [ProjectClient.client.id],
  /// must be sent in the request's body and are parsed into a
  /// [ProjectClient] object for insertion.
  ///
  /// Returns a 200 response with the new resource.
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

  /// Updates a client's data for a project
  ///
  /// The [ProjectClient.id] isn't used to identify the resource. Instead,
  /// both [ProjectClient.project.id] and [ProjectClient.client.id] are
  /// taken from the request's path.
  ///
  /// New values for the resource must be sent in the request's body and
  /// are parsed into a [ProjectClient] object.
  ///
  /// Returns a 200 response with the updated resource.
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

  /// Deletes a client's data for a project.
  ///
  /// The [ProjectClient.id] isn't used to identify the resource. Instead,
  /// both [ProjectClient.project.id] and [ProjectClient.client.id] are
  /// taken from the request's path.
  ///
  /// Also deletes any resource of [RequirementValue] that existed for the
  /// client in the project.
  ///
  /// Returns a 200 response with the number of rows deleted.
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
