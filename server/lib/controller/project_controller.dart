import '../model/project.dart';
import '../model/user.dart';

import '../nrp_server.dart';

class ProjectController extends ResourceController {
  ProjectController(this.context);

  ManagedContext context;

  @Operation.get()
  Future<Response> getAllProjects() async {
    final getAllProjectsQuery = Query<Project>(context)
      ..where((p) => p.owner.id).equalTo(request.authorization.ownerID);

    // TODO: Add pagination.

    final fetchedProjects = await getAllProjectsQuery.fetch();

    return Response.ok(fetchedProjects);
  }

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

  @Operation.post()
  Future<Response> addProject(@Bind.body() Project newProject) async {
    final addProjectQuery = Query<Project>(context)
      ..values = newProject
      ..values.owner.id = request.authorization.ownerID;

    final insertedProject = await addProjectQuery.insert();

    return Response.ok(insertedProject);
  }

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
