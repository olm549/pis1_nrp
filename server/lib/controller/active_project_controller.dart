import '../model/project.dart';

import '../nrp_server.dart';

/// A controller that handles requests involving the active [Project] resource
/// for a user.
class ActiveProjectController extends ResourceController {
  ActiveProjectController(this.context);

  ManagedContext context;

  /// Fetches the currently active project resource for a user.
  ///
  /// This method returns a 200 response with the active [Project] resource if
  /// there is one. If there isn't, a 404 response is returned instead.
  @Operation.get()
  Future<Response> getActiveProject() async {
    final getActiveProjectQuery = Query<Project>(context)
      ..where((p) => p.owner.id).equalTo(request.authorization.ownerID)
      ..where((p) => p.active).equalTo(true)
      ..returningProperties((p) => [
            p.id,
            p.projectID,
            p.name,
            p.description,
            p.effortLimit,
          ]);

    final fetchedProject = await getActiveProjectQuery.fetchOne();

    if (fetchedProject == null) {
      return Response.notFound();
    } else {
      return Response.ok(fetchedProject);
    }
  }

  /// Changes the currently active project for a user.
  ///
  /// The previously active [Project] resource has its [Project.active] property
  /// set to `false` and the new active one has its set to `true`.
  ///
  /// The new active [Project] is identified using a query parameter that contains
  /// its [Project.id].
  ///
  /// Returns a 200 response with the new active [Project] resource.
  @Operation.put()
  Future<Response> updateActiveProject(
      @Bind.query('newID') int newProjectID) async {
    final newActiveProject = await context.transaction((transaction) async {
      var updateActiveProjectQuery = Query<Project>(transaction)
        ..where((p) => p.owner.id).equalTo(request.authorization.ownerID)
        ..where((p) => p.active).equalTo(true)
        ..values.active = false;

      final oldActiveProject = await updateActiveProjectQuery.fetchOne();

      if (oldActiveProject != null) {
        await updateActiveProjectQuery.updateOne();
      }

      updateActiveProjectQuery = Query<Project>(transaction)
        ..where((p) => p.id).equalTo(newProjectID)
        ..values.active = true;

      return await updateActiveProjectQuery.updateOne();
    });

    return Response.ok(newActiveProject);
  }
}
