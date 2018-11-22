import '../model/project.dart';
import '../model/requirement.dart';

import '../nrp_server.dart';

/// A controller that handles requests for the [Requirement] resources.
class RequirementController extends ResourceController {
  RequirementController(this.context);

  ManagedContext context;

  /// Fetches all requirements' data.
  ///
  /// A list of [Requirement] resources is returned in the body of a 200 response.
  @Operation.get()
  Future<Response> getAllRequirements() async {
    final getAllRequirementsQuery = Query<Requirement>(context);

    // TODO: Add pagination.

    final fetchedRequirements = await getAllRequirementsQuery.fetch();

    return Response.ok(fetchedRequirements);
  }

  /// Fetches a certain requirement's data.
  ///
  /// The [Requirement.id] of the desired resource is taken from the path of the
  /// request.
  ///
  /// Returns a 200 response with the [Requirement] resource in its body joined
  /// with the list of [Project] resources it is associated to.
  @Operation.get('requirementID')
  Future<Response> getRequirement(@Bind.path('requirementID') int id) async {
    final getRequirementQuery = Query<Requirement>(context)
      ..where((r) => r.id).equalTo(id);

    getRequirementQuery.join(set: (r) => r.projects)
      ..returningProperties((pr) => [pr.id, pr.project])
      ..join(object: (pr) => pr.project);

    final fetchedRequirement = await getRequirementQuery.fetchOne();

    return Response.ok(fetchedRequirement);
  }

  /// Inserts a new requirement.
  ///
  /// Values of the new resource must be sent in the request's body and
  /// are parsed into a [Requirement] object for insertion.
  ///
  /// Returns a 200 response with the new resource.
  @Operation.post()
  Future<Response> addRequirement(
    @Bind.body() Requirement newRequirement,
  ) async {
    final addRequirementQuery = Query<Requirement>(context)
      ..values = newRequirement;

    final insertedRequirement = await addRequirementQuery.insert();

    return Response.ok(insertedRequirement);
  }

  /// Updates a requirement's data.
  ///
  /// The [Requirement.id] of the desired resource is taken from the path of the
  /// request.
  ///
  /// New values for the resource must be sent in the request's body and
  /// are parsed into a [Requirement] object.
  ///
  /// Returns a 200 response with the updated resource.
  @Operation.put('requirementID')
  Future<Response> modifyRequirement(
    @Bind.path('requirementID') int id,
    @Bind.body() Requirement requirement,
  ) async {
    final modifyRequirementQuery = Query<Requirement>(context)
      ..where((r) => r.id).equalTo(id)
      ..values = requirement;

    final updatedRequirement = await modifyRequirementQuery.updateOne();

    return Response.ok(updatedRequirement);
  }

  /// Deletes a requirement.
  ///
  /// The [Requirement.id] of the desired resource is taken from the path of the
  /// request.
  ///
  /// Returns a 200 response with the number of rows deleted.
  @Operation.delete('requirementID')
  Future<Response> deleteRequirement(
    @Bind.path('requirementID') int id,
  ) async {
    final deleteRequirementQuery = Query<Requirement>(context)
      ..where((r) => r.id).equalTo(id);

    final rowsDeleted = await deleteRequirementQuery.delete();

    return Response.ok({
      'rowsDeleted': rowsDeleted,
    });
  }
}
