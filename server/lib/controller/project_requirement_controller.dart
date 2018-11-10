import '../model/project.dart';
import '../model/project_requirement.dart';
import '../model/requirement.dart';

import '../nrp_server.dart';

class ProjectRequirementController extends ResourceController {
  ManagedContext context;

  ProjectRequirementController(this.context);

  @Operation.get('projectID')
  Future<Response> getAllProjectRequirements(
    @Bind.path('projectID') int projectID,
  ) async {
    final getAllProjectRequirementsQuery = Query<ProjectRequirement>(context)
      ..join(object: (pr) => pr.requirement)
      ..where((pr) => pr.project.owner.id)
          .equalTo(request.authorization.ownerID)
      ..where((pr) => pr.requirement.owner.id)
          .equalTo(request.authorization.ownerID)
      ..where((pr) => pr.project.id).equalTo(projectID);

    // TODO: Add pagination.

    return Response.ok(await getAllProjectRequirementsQuery.fetch());
  }

  @Operation.get('projectID', 'requirementID')
  Future<Response> getProjectRequirement(
    @Bind.path('projectID') int projectID,
    @Bind.path('requirementID') int requirementID,
  ) async {
    final getProjectRequirementQuery = Query<ProjectRequirement>(context)
      ..join(object: (pr) => pr.requirement)
      ..where((pr) => pr.project.owner.id)
          .equalTo(request.authorization.ownerID)
      ..where((pr) => pr.requirement.owner.id)
          .equalTo(request.authorization.ownerID)
      ..where((pr) => pr.project.id).equalTo(projectID)
      ..where((pr) => pr.requirement.id).equalTo(requirementID);

    return Response.ok(await getProjectRequirementQuery.fetchOne());
  }

  @Operation.post()
  Future<Response> addProjectRequirement(@Bind.body() Map content) async {
    final getProjectQuery = Query<Project>(context)
      ..where((p) => p.owner.id).equalTo(request.authorization.ownerID)
      ..where((p) => p.id)
          .equalTo(int.tryParse(content['projectID'].toString()));

    final getRequirementQuery = Query<Requirement>(context)
      ..where((r) => r.owner.id).equalTo(request.authorization.ownerID)
      ..where((r) => r.id)
          .equalTo(int.tryParse(content['requirementID'].toString()));

    final project = await getProjectQuery.fetchOne();
    final requirement = await getRequirementQuery.fetchOne();

    final addProjectRequirementQuery = Query<ProjectRequirement>(context)
      ..values.project = project
      ..values.requirement = requirement
      ..values.estimatedEffort =
          double.tryParse(content['estimatedEffort'].toString())
      ..values.satisfaction =
          double.tryParse(content['satisfaction'].toString());

    return Response.ok(await addProjectRequirementQuery.insert());
  }

  @Operation.put('projectID', 'requirementID')
  Future<Response> modifyProjectRequirement(
    @Bind.path('projectID') int projectID,
    @Bind.path('requirementID') int requirementID,
    @Bind.body() ProjectRequirement projectRequirement,
  ) async {
    final modifyProjectRequirementQuery = Query<ProjectRequirement>(context)
      ..where((pr) => pr.project.owner.id)
          .equalTo(request.authorization.ownerID)
      ..where((pr) => pr.requirement.owner.id)
          .equalTo(request.authorization.ownerID)
      ..where((pr) => pr.project.id).equalTo(projectID)
      ..where((pr) => pr.requirement.id).equalTo(requirementID)
      ..values = projectRequirement;

    return Response.ok(await modifyProjectRequirementQuery.updateOne());
  }

  @Operation.delete('projectID', 'requirementID')
  Future<Response> deleteprojectRequirement(
    @Bind.path('projectID') int projectID,
    @Bind.path('requirementID') int requirementID,
  ) async {
    final deleteProjectRequirementQuery = Query<ProjectRequirement>(context)
      ..where((pr) => pr.project.owner.id)
          .equalTo(request.authorization.ownerID)
      ..where((pr) => pr.requirement.owner.id)
          .equalTo(request.authorization.ownerID)
      ..where((pr) => pr.project.id).equalTo(projectID)
      ..where((pr) => pr.requirement.id).equalTo(requirementID);

    return Response.ok(await deleteProjectRequirementQuery.delete());
  }
}
