import '../model/project.dart';

import '../nrp_server.dart';

/// A controller that handles requests for the [Project] resources.
class ProjectController extends ResourceController {
  ProjectController(this.context);

  ManagedContext context;

  /// Fetches all projects' data.
  ///
  /// This method only returns data from projects that have the requesting
  /// user as [Project.owner].
  ///
  /// A list of [Project] resources is returned in the body of a 200 response.
  @Operation.get()
  Future<Response> getAllProjects() async {
    final getAllProjectsQuery = Query<Project>(context)
      ..where((p) => p.owner.id).equalTo(request.authorization.ownerID);

    // TODO: Add pagination.

    final fetchedProjects = await getAllProjectsQuery.fetch();

    return Response.ok(fetchedProjects);
  }

  /// Fetches a certain project's data.
  ///
  /// The [Project.id] of the desired resource is taken from the path of the
  /// request.
  ///
  /// Returns a 200 response with the [Project] resource in the body only if
  /// the requesting user is specified as [Project.owner]. If not, returns
  /// a 401 response.
  @Operation.get('projectID')
  Future<Response> getProject(@Bind.path('projectID') int id) async {
    final getProjectQuery = Query<Project>(context)
      ..where((p) => p.id).equalTo(id);

    final fetchedProject = await getProjectQuery.fetchOne();

    if (fetchedProject.owner.id != request.authorization.ownerID) {
      return Response.unauthorized();
    } else {
      return Response.ok(fetchedProject);
    }
  }

  /// Inserts a new project.
  ///
  /// Values of the new resource must be sent in the request's body and
  /// are parsed into a [Project] object for insertion.
  ///
  /// The new resource is given the requesting user as [Project.owner].
  ///
  /// Returns a 200 response with the new resource.
  @Operation.post()
  Future<Response> addProject(@Bind.body() Project newProject) async {
    final addProjectQuery = Query<Project>(context)
      ..values = newProject
      ..values.owner.id = request.authorization.ownerID;

    final insertedProject = await addProjectQuery.insert();

    return Response.ok(insertedProject);
  }

  /// Updates a project's data.
  ///
  /// The [Project.id] of the desired resource is taken from the path of the
  /// request.
  ///
  /// New values for the resource must be sent in the request's body and
  /// are parsed into a [Project] object.
  ///
  /// Returns a 200 response with the updated resource if the requesting user
  /// is specified as [Project.owner] of the desired resource. If not, returns
  /// a 401 response.
  @Operation.put('projectID')
  Future<Response> modifyProject(
    @Bind.path('projectID') int id,
    @Bind.body() Project project,
  ) async {
    final modifyProjectQuery = Query<Project>(context)
      ..where((p) => p.id).equalTo(id)
      ..values = project;

    final projectToUpdate = await modifyProjectQuery.fetchOne();

    if (projectToUpdate.owner.id != request.authorization.ownerID) {
      return Response.unauthorized();
    } else {
      final updatedProject = await modifyProjectQuery.updateOne();

      return Response.ok(updatedProject);
    }
  }

  /// Deletes a project.
  ///
  /// The [Project.id] of the desired resource is taken from the path of the
  /// request.
  ///
  /// Returns a 200 response with the number of rows deleted only if the
  /// requesting user is specified as [Project.owner] of the desired resource.
  /// If not, a 401 response is returned.
  @Operation.delete('projectID')
  Future<Response> deleteProject(@Bind.path('projectID') int id) async {
    final deleteProjectQuery = Query<Project>(context)
      ..where((p) => p.id).equalTo(id);

    final projectToDelete = await deleteProjectQuery.fetchOne();

    if (projectToDelete.owner.id != request.authorization.ownerID) {
      return Response.unauthorized();
    } else {
      final rowsDeleted = await deleteProjectQuery.delete();

      return Response.ok({
        'rowsDeleted': rowsDeleted,
      });
    }
  }
}
