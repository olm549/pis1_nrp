import '../model/project.dart';
import '../model/user.dart';

import '../nrp_server.dart';

class ProjectController extends ResourceController {
  ManagedContext context;

  ProjectController(this.context);

  @Operation.get()
  Future<Response> getAllProjects() async {
    final getAllProjectsQuery = Query<Project>(context)
      ..where((p) => p.owner.id).equalTo(request.authorization.ownerID);

    // TODO: Add pagination.

    return Response.ok(await getAllProjectsQuery.fetch());
  }

  @Operation.get('projectID')
  Future<Response> getProject(@Bind.path('projectID') int id) async {
    final getProjectQuery = Query<Project>(context)
      ..where((p) => p.owner.id).equalTo(request.authorization.ownerID)
      ..where((p) => p.id).equalTo(id);

    return Response.ok(await getProjectQuery.fetchOne());
  }

  @Operation.post()
  Future<Response> addProject(@Bind.body() Project newProject) async {
    final getUserQuery = Query<User>(context)
      ..where((u) => u.id).equalTo(request.authorization.ownerID);

    final user = await getUserQuery.fetchOne();
    newProject.owner = user;

    final addProjectQuery = Query<Project>(context)..values = newProject;

    return Response.ok(await addProjectQuery.insert());
  }

  @Operation.put('projectID')
  Future<Response> modifyProject(
    @Bind.path('projectID') int id,
    @Bind.body() Project project,
  ) async {
    final modifyProjectQuery = Query<Project>(context)
      ..where((p) => p.owner.id).equalTo(request.authorization.ownerID)
      ..where((p) => p.id).equalTo(id)
      ..values = project;

    return Response.ok(await modifyProjectQuery.updateOne());
  }

  @Operation.delete('projectID')
  Future<Response> deleteProject(@Bind.path('projectID') int id) async {
    /*final deleteProjectQuery = Query<Project>(context)
      ..where((p) => p.id).equalTo(id);

    final project = await deleteProjectQuery.fetchOne();

    if (project == null) {
      return Response.notFound();
    } else if (project.owner.id != request.authorization.ownerID) {
      return Response.unauthorized();
    } else {
      return Response.ok(await deleteProjectQuery.delete());
    }*/

    final deleteProjectQuery = Query<Project>(context)
      ..where((p) => p.owner.id).equalTo(request.authorization.ownerID)
      ..where((p) => p.id).equalTo(id);

    return Response.ok(await deleteProjectQuery.delete());
  }
}
