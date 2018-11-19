import '../model/requirement.dart';

import '../nrp_server.dart';

/// A controller that handles requests for the [Requirement] resources.
class RequirementController extends ResourceController {
  RequirementController(this.context);

  ManagedContext context;

  /// Fetches all requirements' data.
  ///
  /// This method only returns data from requirements that have the requesting
  /// user as [Requirement.owner].
  ///
  /// A list of [Requirement] resources is returned in the body of a 200 response.
  @Operation.get()
  Future<Response> getAllRequirements() async {
    final getAllRequirementsQuery = Query<Requirement>(context)
      ..where((r) => r.owner.id).equalTo(request.authorization.ownerID);

    // TODO: Add pagination.

    final fetchedRequirements = await getAllRequirementsQuery.fetch();

    return Response.ok(fetchedRequirements);
  }

  /// Fetches a certain requirement's data.
  ///
  /// The [Requirement.id] of the desired resource is taken from the path of the
  /// request.
  ///
  /// Returns a 200 response with the [Requirement] resource in the body only if
  /// the requesting user is specified as [Requirement.owner]. If not, returns
  /// a 401 response.
  @Operation.get('requirementID')
  Future<Response> getRequirement(@Bind.path('requirementID') int id) async {
    final getRequirementQuery = Query<Requirement>(context)
      ..where((r) => r.id).equalTo(id);

    final fetchedRequirement = await getRequirementQuery.fetchOne();

    if (fetchedRequirement.owner.id != request.authorization.ownerID) {
      return Response.unauthorized();
    } else {
      return Response.ok(fetchedRequirement);
    }
  }

  /// Inserts a new requirement.
  ///
  /// Values of the new resource must be sent in the request's body and
  /// are parsed into a [Requirement] object for insertion.
  ///
  /// The new resource is given the requesting user as [Requirement.owner].
  ///
  /// Returns a 200 response with the new resource.
  @Operation.post()
  Future<Response> addRequirement(
    @Bind.body() Requirement newRequirement,
  ) async {
    final addRequirementQuery = Query<Requirement>(context)
      ..values = newRequirement
      ..values.owner.id = request.authorization.ownerID;

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
  /// Returns a 200 response with the updated resource if the requesting user
  /// is specified as [Requirement.owner] of the desired resource. If not, returns
  /// a 401 response.
  @Operation.put('requirementID')
  Future<Response> modifyRequirement(
    @Bind.path('requirementID') int id,
    @Bind.body() Requirement requirement,
  ) async {
    final modifyRequirementQuery = Query<Requirement>(context)
      ..where((r) => r.id).equalTo(id)
      ..values = requirement;

    final requirementToUpdate = await modifyRequirementQuery.fetchOne();

    if (requirementToUpdate.owner.id != request.authorization.ownerID) {
      return Response.unauthorized();
    } else {
      final updatedRequirement = await modifyRequirementQuery.updateOne();

      return Response.ok(updatedRequirement);
    }
  }

  /// Deletes a requirement.
  ///
  /// The [Requirement.id] of the desired resource is taken from the path of the
  /// request.
  ///
  /// Returns a 200 response with the number of rows deleted only if the
  /// requesting user is specified as [Requirement.owner] of the desired resource.
  /// If not, a 401 response is returned.
  @Operation.delete('requirementID')
  Future<Response> deleteRequirement(
    @Bind.path('requirementID') int id,
  ) async {
    final deleteRequirementQuery = Query<Requirement>(context)
      ..where((r) => r.id).equalTo(id);

    final requirementToDelete = await deleteRequirementQuery.fetchOne();

    if (requirementToDelete.owner.id != request.authorization.ownerID) {
      return Response.unauthorized();
    } else {
      final rowsDeleted = await deleteRequirementQuery.delete();

      return Response.ok({
        'rowsDeleted': rowsDeleted,
      });
    }
  }
}
