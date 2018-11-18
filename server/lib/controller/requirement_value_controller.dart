import '../model/requirement_value.dart';

import '../nrp_server.dart';

class RequirementValueController extends ResourceController {
  RequirementValueController(this.context);

  ManagedContext context;

  @Operation.get('projectID', 'requirementID')
  Future<Response> getRequirementValues(
    @Bind.path('projectID') int projectID,
    @Bind.path('requirementID') int requirementID,
  ) async {
    final getRequirementValuesQuery = Query<RequirementValue>(context)
      ..where((rv) => rv.project.id).equalTo(projectID)
      ..where((rv) => rv.requirement.id).equalTo(requirementID)
      ..join(object: (rv) => rv.client);

    // TODO: Add pagination.

    final fetchedRequirementValues = await getRequirementValuesQuery.fetch();

    return Response.ok(fetchedRequirementValues);
  }

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
      ..join(object: (rv) => rv.client);

    final fetchedRequirementValue = await getRequirementValueQuery.fetchOne();

    return Response.ok(fetchedRequirementValue);
  }

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
