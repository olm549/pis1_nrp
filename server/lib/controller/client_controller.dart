import '../model/client.dart';
import '../model/project.dart';

import '../server.dart';

/// A controller that handles requests for the [Client] resources.
class ClientController extends ResourceController {
  ClientController(this.context);

  ManagedContext context;

  /// Fetches all clients' data.
  ///
  /// A list of [Client] resources is returned in the body of a 200 response.
  @Operation.get()
  Future<Response> getAllClients() async {
    final getAllClientsQuery = Query<Client>(context);

    // TODO: Add pagination.

    final fetchedClients = await getAllClientsQuery.fetch();

    return Response.ok(fetchedClients);
  }

  /// Fetches a certain client's data.
  ///
  /// The [Client.id] of the desired resource is taken from the path of the
  /// request.
  ///
  /// Returns a 200 response with the [Client] resource in its body joined with
  /// the list of [Project] resources it is associated to.
  @Operation.get('clientID')
  Future<Response> getClient(@Bind.path('clientID') int id) async {
    final getClientQuery = Query<Client>(context)
      ..where((c) => c.id).equalTo(id);

    getClientQuery.join(set: (c) => c.projects)
      ..returningProperties((pc) => [pc.id, pc.project])
      ..join(object: (pc) => pc.project);

    final fetchedClient = await getClientQuery.fetchOne();

    return Response.ok(fetchedClient);
  }

  /// Inserts a new client.
  ///
  /// Values of the new resource must be sent in the request's body and
  /// are parsed into a [Client] object for insertion.
  ///
  /// Returns a 200 response with the new resource.
  @Operation.post()
  Future<Response> addClient(@Bind.body() Client newClient) async {
    final addClientQuery = Query<Client>(context)..values = newClient;

    final insertedClient = await addClientQuery.insert();

    return Response.ok(insertedClient);
  }

  /// Updates a client's data.
  ///
  /// The [Client.id] of the desired resource is taken from the path of the
  /// request.
  ///
  /// New values for the resource must be sent in the request's body and
  /// are parsed into a [Client] object.
  ///
  /// Returns a 200 response with the updated resource.
  @Operation.put('clientID')
  Future<Response> modifyClient(
    @Bind.path('clientID') int id,
    @Bind.body() Client client,
  ) async {
    final modifyClientQuery = Query<Client>(context)
      ..where((c) => c.id).equalTo(id)
      ..values = client;

    final updatedClient = await modifyClientQuery.updateOne();

    return Response.ok(updatedClient);
  }

  /// Deletes a client.
  ///
  /// The [Client.id] of the desired resource is taken from the path of the
  /// request.
  ///
  /// Returns a 200 response with the number of rows deleted.
  @Operation.delete('clientID')
  Future<Response> deleteClient(@Bind.path('clientID') int id) async {
    final deleteClientQuery = Query<Client>(context)
      ..where((c) => c.id).equalTo(id);

    final rowsDeleted = await deleteClientQuery.delete();

    return Response.ok({
      'rowsDeleted': rowsDeleted,
    });
  }
}
