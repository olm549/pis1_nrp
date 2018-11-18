import '../model/client.dart';
import '../model/user.dart';

import '../nrp_server.dart';

class ClientController extends ResourceController {
  ClientController(this.context);

  ManagedContext context;

  @Operation.get()
  Future<Response> getAllClients() async {
    final getAllClientsQuery = Query<Client>(context)
      ..where((c) => c.owner.id).equalTo(request.authorization.ownerID);

    // TODO: Add pagination.

    final fetchedClients = await getAllClientsQuery.fetch();

    return Response.ok(fetchedClients);
  }

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

  @Operation.post()
  Future<Response> addClient(@Bind.body() Client newClient) async {
    final addClientQuery = Query<Client>(context)
      ..values = newClient
      ..values.owner.id = request.authorization.ownerID;

    final insertedClient = await addClientQuery.insert();

    return Response.ok(insertedClient);
  }

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
