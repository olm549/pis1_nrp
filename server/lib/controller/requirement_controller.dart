import '../model/requirement.dart';
import '../model/user.dart';

import '../nrp_server.dart';

class RequirementController extends ResourceController {
  RequirementController(this.context);

  ManagedContext context;

  @Operation.get()
  Future<Response> getAllRequirements() async {
    final getAllRequirementsQuery = Query<Requirement>(context)
      ..where((r) => r.owner.id).equalTo(request.authorization.ownerID);

    // TODO: Add pagination.

    final fetchedRequirements = await getAllRequirementsQuery.fetch();

    return Response.ok(fetchedRequirements);
  }

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
