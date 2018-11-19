import '../model/client.dart';

import '../nrp_server.dart';

/// A controller that handles requests for the [Client] resources.
class ClientController extends ResourceController {
  ClientController(this.context);

  ManagedContext context;

  /// Fetches all clients' data.
  ///
  /// This method only returns data from clients that have the requesting
  /// user as [Client.owner].
  ///
  /// A list of [Client] resources is returned in the body of a 200 response.
  @Operation.get()
  Future<Response> getAllClients() async {
    final getAllClientsQuery = Query<Client>(context)
      ..where((c) => c.owner.id).equalTo(request.authorization.ownerID);

    // TODO: Add pagination.

    final fetchedClients = await getAllClientsQuery.fetch();

    return Response.ok(fetchedClients);
  }

  /// Fetches a certain client's data.
  ///
  /// The [Client.id] of the desired resource is taken from the path of the
  /// request.
  ///
  /// Returns a 200 response with the [Client] resource in the body only if
  /// the requesting user is specified as [Client.owner]. If not, returns
  /// a 401 response.
  @Operation.get('clientID')
  Future<Response> getClient(@Bind.path('clientID') int id) async {
    final getClientQuery = Query<Client>(context)
      ..where((c) => c.id).equalTo(id);

    final fetchedClient = await getClientQuery.fetchOne();

    if (fetchedClient.owner.id != request.authorization.ownerID) {
      return Response.unauthorized();
    } else {
      return Response.ok(fetchedClient);
    }
  }

  /// Inserts a new client.
  ///
  /// Values of the new resource must be sent in the request's body and
  /// are parsed into a [Client] object for insertion.
  ///
  /// The new resource is given the requesting user as [Client.owner].
  ///
  /// Returns a 200 response with the new resource.
  @Operation.post()
  Future<Response> addClient(@Bind.body() Client newClient) async {
    final addClientQuery = Query<Client>(context)
      ..values = newClient
      ..values.owner.id = request.authorization.ownerID;

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
  /// Returns a 200 response with the updated resource if the requesting user
  /// is specified as [Client.owner] of the desired resource. If not, returns
  /// a 401 response.
  @Operation.put('clientID')
  Future<Response> modifyClient(
    @Bind.path('clientID') int id,
    @Bind.body() Client client,
  ) async {
    final modifyClientQuery = Query<Client>(context)
      ..where((c) => c.id).equalTo(id)
      ..values = client;

    final clientToUpdate = await modifyClientQuery.fetchOne();

    if (clientToUpdate.owner.id != request.authorization.ownerID) {
      return Response.unauthorized();
    } else {
      final updatedClient = await modifyClientQuery.updateOne();

      return Response.ok(updatedClient);
    }
  }

  /// Deletes a client.
  ///
  /// The [Client.id] of the desired resource is taken from the path of the
  /// request.
  ///
  /// Returns a 200 response with the number of rows deleted only if the
  /// requesting user is specified as [Client.owner] of the desired resource.
  /// If not, a 401 response is returned.
  @Operation.delete('clientID')
  Future<Response> deleteClient(@Bind.path('clientID') int id) async {
    final deleteClientQuery = Query<Client>(context)
      ..where((c) => c.id).equalTo(id);

    final clientToDelete = await deleteClientQuery.fetchOne();

    if (clientToDelete.owner.id != request.authorization.ownerID) {
      return Response.unauthorized();
    } else {
      final rowsDeleted = await deleteClientQuery.delete();

      return Response.ok({
        'rowsDeleted': rowsDeleted,
      });
    }
  }
}
