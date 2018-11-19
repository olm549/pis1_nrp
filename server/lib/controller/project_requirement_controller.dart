import '../model/project_requirement.dart';
import '../model/requirement_value.dart';

import '../nrp_server.dart';

/// A controller that handles requests for the [ProjectRequirement] resources.
class ProjectRequirementController extends ResourceController {
  ProjectRequirementController(this.context);

  ManagedContext context;

  /// Fetches all requirement's data for a project.
  ///
  /// A list of [ProjectRequirement] resources joined with the requirement's
  /// data is returned in the body of a 200 response.
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

  /// Fetches a certain requirement's data for a project.
  ///
  /// The [ProjectRequirement.id] isn't used to fetch the resource. Instead,
  /// both [ProjectRequirement.project.id] and [ProjectRequirement.requirement.id] are
  /// taken from the request's path.
  ///
  /// Returns a 200 response with the [ProjectRequirement] resource and the
  /// requirement's data.
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

  /// Inserts a new project requirement.
  ///
  /// Values of the new resource, including [ProjectRequirement.requirement.id],
  /// must be sent in the request's body and are parsed into a
  /// [ProjectRequirement] object for insertion.
  ///
  /// Returns a 200 response with the new resource.
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

  /// Updates a requirement's data for a project
  ///
  /// The [ProjectRequirement.id] isn't used to identify the resource. Instead,
  /// both [ProjectRequirement.project.id] and [ProjectRequirement.requirement.id] are
  /// taken from the request's path.
  ///
  /// New values for the resource must be sent in the request's body and
  /// are parsed into a [ProjectRequirement] object.
  ///
  /// Returns a 200 response with the updated resource.
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

  /// Deletes a requirement's data for a project.
  ///
  /// The [ProjectRequirement.id] isn't used to identify the resource. Instead,
  /// both [ProjectRequirement.project.id] and [ProjectRequirement.requirement.id] are
  /// taken from the request's path.
  ///
  /// Also deletes any resource of [RequirementValue] that existed for the
  /// requirement in the project.
  ///
  /// Returns a 200 response with the number of rows deleted.
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
