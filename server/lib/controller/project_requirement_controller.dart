import '../model/project_requirement.dart';
import '../model/requirement_value.dart';

import '../nrp_server.dart';

class ProjectRequirementController extends ResourceController {
  ProjectRequirementController(this.context);

  ManagedContext context;

  @Operation.get('projectID')
  Future<Response> getAllProjectRequirements(
    @Bind.path('projectID') int projectID,
  ) async {
    final getAllProjectRequirementsQuery = Query<ProjectRequirement>(context)
      ..where((pr) => pr.project.id).equalTo(projectID)
      ..join(object: (pr) => pr.requirement);

    // TODO: Add pagination.

    final fetchedProjectRequirements =
        await getAllProjectRequirementsQuery.fetch();

    return Response.ok(fetchedProjectRequirements);
  }

  @Operation.get('projectID', 'requirementID')
  Future<Response> getProjectRequirement(
    @Bind.path('projectID') int projectID,
    @Bind.path('requirementID') int requirementID,
  ) async {
    final getProjectRequirementQuery = Query<ProjectRequirement>(context)
      ..where((pr) => pr.project.id).equalTo(projectID)
      ..where((pr) => pr.requirement.id).equalTo(requirementID)
      ..join(object: (pr) => pr.requirement);

    final fetchedProjectRequirement =
        await getProjectRequirementQuery.fetchOne();

    return Response.ok(fetchedProjectRequirement);
  }

  @Operation.post('projectID')
  Future<Response> addProjectRequirement(
    @Bind.path('projectID') int projectID,
    @Bind.body() ProjectRequirement newProjectRequirement,
  ) async {
    final addProjectRequirementQuery = Query<ProjectRequirement>(context)
      ..values = newProjectRequirement
      ..values.project.id = projectID;

    final insertedProjectRequirement =
        await addProjectRequirementQuery.insert();

    return Response.ok(insertedProjectRequirement);
  }

  @Operation.put('projectID', 'requirementID')
  Future<Response> modifyProjectRequirement(
    @Bind.path('projectID') int projectID,
    @Bind.path('requirementID') int requirementID,
    @Bind.body() ProjectRequirement projectRequirement,
  ) async {
    final modifyProjectRequirementQuery = Query<ProjectRequirement>(context)
      ..where((pr) => pr.project.id).equalTo(projectID)
      ..where((pr) => pr.requirement.id).equalTo(requirementID)
      ..values = projectRequirement;

    final updatedProjectRequirement =
        await modifyProjectRequirementQuery.updateOne();

    return Response.ok(updatedProjectRequirement);
  }

  @Operation.delete('projectID', 'requirementID')
  Future<Response> deleteProjectRequirement(
    @Bind.path('projectID') int projectID,
    @Bind.path('requirementID') int requirementID,
  ) async {
    final Future<Response> response = context.transaction((transaction) async {
      final deleteProjectRequirementQuery =
          Query<ProjectRequirement>(transaction)
            ..where((pr) => pr.project.id).equalTo(projectID)
            ..where((pr) => pr.requirement.id).equalTo(requirementID);

      final projectRequirementRowsDeleted =
          await deleteProjectRequirementQuery.delete();

      final deleteRequirementValuesQuery = Query<RequirementValue>(transaction)
        ..where((rv) => rv.project.id).equalTo(projectID)
        ..where((rv) => rv.requirement.id).equalTo(requirementID);

      final requirementValuesRowsDeleted =
          await deleteRequirementValuesQuery.delete();

      return Response.ok({
        'projectRequirementRowsDeleted': projectRequirementRowsDeleted,
        'requirementValuesRowsDeleted': requirementValuesRowsDeleted,
      });
    });

    return response;
  }
}
