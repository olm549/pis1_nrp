import '../model/requirement.dart';
import '../model/user.dart';

import '../nrp_server.dart';

class RequirementController extends ResourceController {
  ManagedContext context;

  RequirementController(this.context);

  @Operation.get()
  Future<Response> getAllRequirements() async {
    final getAllRequirementsQuery = Query<Requirement>(context)
      ..where((r) => r.owner.id).equalTo(request.authorization.ownerID);

    // TODO: Add pagination.

    return Response.ok(await getAllRequirementsQuery.fetch());
  }

  @Operation.get('requirementID')
  Future<Response> getRequirement(@Bind.path('requirementID') int id) async {
    final getRequirementQuery = Query<Requirement>(context)
      ..where((r) => r.owner.id).equalTo(request.authorization.ownerID)
      ..where((r) => r.id).equalTo(id);

    return Response.ok(await getRequirementQuery.fetchOne());
  }

  @Operation.post()
  Future<Response> addRequirement(
    @Bind.body() Requirement newRequirement,
  ) async {
    final getUserQuery = Query<User>(context)
      ..where((u) => u.id).equalTo(request.authorization.ownerID);

    final user = await getUserQuery.fetchOne();
    newRequirement.owner = user;

    final addRequirementQuery = Query<Requirement>(context)
      ..values = newRequirement;

    return Response.ok(await addRequirementQuery.insert());
  }

  @Operation.put('requirementID')
  Future<Response> modifyRequirement(
    @Bind.path('requirementID') int id,
    @Bind.body() Requirement requirement,
  ) async {
    final modifyRequirementQuery = Query<Requirement>(context)
      ..where((r) => r.owner.id).equalTo(request.authorization.ownerID)
      ..where((r) => r.id).equalTo(id)
      ..values = requirement;

    return Response.ok(await modifyRequirementQuery.updateOne());
  }

  @Operation.delete('requirementID')
  Future<Response> deleteRequirement(
    @Bind.path('requirementID') int id,
  ) async {
    final deleteRequirementQuery = Query<Requirement>(context)
      ..where((r) => r.owner.id).equalTo(request.authorization.ownerID)
      ..where((r) => r.id).equalTo(id);

    return Response.ok(await deleteRequirementQuery.delete());
  }
}
