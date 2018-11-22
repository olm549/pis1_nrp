import '../model/requirement_value.dart';

import '../nrp_server.dart';

/// A controller that handles requests for the [RequirementValue] resources.
class RequirementValueController extends ResourceController {
  RequirementValueController(this.context);

  ManagedContext context;

  /// Fetches all requirement values for a project.
  ///
  /// A list of [RequirementValue] resources joined with the client and
  /// project's data is returned in the body of a 200 response.
  @Operation.get('projectID', 'requirementID')
  Future<Response> getRequirementValues(
    @Bind.path('projectID') int projectID,
    @Bind.path('requirementID') int requirementID,
  ) async {
    final getRequirementValuesQuery = Query<RequirementValue>(context)
      ..where((rv) => rv.project.id).equalTo(projectID)
      ..where((rv) => rv.requirement.id).equalTo(requirementID)
      ..returningProperties((rv) => [
            rv.id,
            rv.value,
            rv.requirement,
            rv.client,
          ])
      ..join(object: (rv) => rv.requirement)
      ..join(object: (rv) => rv.client);

    // TODO: Add pagination.

    final fetchedRequirementValues = await getRequirementValuesQuery.fetch();

    return Response.ok(fetchedRequirementValues);
  }

  /// Fetches a requirement value for a client in a project.
  ///
  /// The [RequirementValue.id] isn't used to identify the resource. Instead,
  /// [RequirementValue.project.id], [RequirementValue.requirement.id] and
  /// [RequirementValue.client.id] are taken from the request´s path.
  ///
  /// Returns a 200 response with the [RequirementValue] resource and the
  /// client and project's data.
  @Operation.get('projectID', 'requirementID', 'clientID')
  Future<Response> getRequirementValue(
    @Bind.path('projectID') int projectID,
    @Bind.path('requirementID') int requirementID,
    @Bind.path('clientID') int clientID,
  ) async {
    final getRequirementValueQuery = Query<RequirementValue>(context)
      ..where((rv) => rv.project.id).equalTo(projectID)
      ..where((rv) => rv.requirement.id).equalTo(requirementID)
      ..where((rv) => rv.client.id).equalTo(clientID)
      ..returningProperties((rv) => [
            rv.id,
            rv.value,
            rv.requirement,
            rv.client,
          ])
      ..join(object: (rv) => rv.requirement)
      ..join(object: (rv) => rv.client);

    final fetchedRequirementValue = await getRequirementValueQuery.fetchOne();

    return Response.ok(fetchedRequirementValue);
  }

  /// Inserts a new requirement value for a project.
  ///
  /// Values for the new resource, including [RequirementValue.client.id],
  /// must be sent in the request's body and are parsed into a [RequirementValue]
  /// object for insertion.
  ///
  /// Returns a 200 response with the new resource.
  @Operation.post('projectID', 'requirementID')
  Future<Response> addRequirementValue(
    @Bind.path('projectID') int projectID,
    @Bind.path('requirementID') int requirementID,
    @Bind.body() RequirementValue newRequirementValue,
  ) async {
    final addRequirementValueQuery = Query<RequirementValue>(context)
      ..values = newRequirementValue
      ..values.project.id = projectID
      ..values.requirement.id = requirementID;

    final insertedRequirementValue = await addRequirementValueQuery.insert();

    return Response.ok(insertedRequirementValue);
  }

  /// Updates a requirement value for a client in a project.
  ///
  /// The [RequirementValue.id] isn't used to identify the resource. Instead,
  /// [RequirementValue.project.id], [RequirementValue.requirement.id] and
  /// [RequirementValue.client.id] are taken from the request´s path.
  ///
  /// New values for the resource must be sent in the request's body and
  /// are parsed into a [RequirementValue] object.
  ///
  /// Returns a 200 response with the updated resource.
  @Operation.put('projectID', 'requirementID', 'clientID')
  Future<Response> modifyRequirementValues(
    @Bind.path('projectID') int projectID,
    @Bind.path('requirementID') int requirementID,
    @Bind.path('clientID') int clientID,
    @Bind.body() RequirementValue projectRequirementClient,
  ) async {
    final modifyRequirementValueQuery = Query<RequirementValue>(context)
      ..where((rv) => rv.project.id).equalTo(projectID)
      ..where((rv) => rv.requirement.id).equalTo(requirementID)
      ..where((rv) => rv.client.id).equalTo(clientID)
      ..values = projectRequirementClient;

    final updatedRequirementValue =
        await modifyRequirementValueQuery.updateOne();

    return Response.ok(updatedRequirementValue);
  }

  /// Deletes a requirement value for a client in a project.
  ///
  /// The [RequirementValue.id] isn't used to identify the resource. Instead,
  /// [RequirementValue.project.id], [RequirementValue.requirement.id] and
  /// [RequirementValue.client.id] are taken from the request´s path.
  ///
  /// Returns a 200 response with the number of rows deleted.
  @Operation.delete('projectID', 'requirementID', 'clientID')
  Future<Response> deleteRequirementValue(
    @Bind.path('projectID') int projectID,
    @Bind.path('requirementID') int requirementID,
    @Bind.path('clientID') int clientID,
  ) async {
    final deleteRequirementValueQuery = Query<RequirementValue>(context)
      ..where((rv) => rv.project.id).equalTo(projectID)
      ..where((rv) => rv.requirement.id).equalTo(requirementID)
      ..where((rv) => rv.client.id).equalTo(clientID);

    final rowsDeleted = await deleteRequirementValueQuery.delete();

    return Response.ok({
      'rowsDeleted': rowsDeleted,
    });
  }
}
