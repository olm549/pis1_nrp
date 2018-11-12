import '../model/client.dart';
import '../model/user.dart';

import '../nrp_server.dart';

class ClientController extends ResourceController {
  ManagedContext context;

  ClientController(this.context);

  @Operation.get()
  Future<Response> getAllClients() async {
    final getAllClientsQuery = Query<Client>(context)
      ..where((c) => c.owner.id).equalTo(request.authorization.ownerID);

    // TODO: Add pagination.

    return Response.ok(await getAllClientsQuery.fetch());
  }

  @Operation.get('clientID')
  Future<Response> getClient(@Bind.path('clientID') int id) async {
    final getClientQuery = Query<Client>(context)
      ..where((c) => c.owner.id).equalTo(request.authorization.ownerID)
      ..where((c) => c.id).equalTo(id);

    return Response.ok(await getClientQuery.fetchOne());
  }

  @Operation.post()
  Future<Response> addClient(@Bind.body() Client newClient) async {
    final getUserQuery = Query<User>(context)
      ..where((u) => u.id).equalTo(request.authorization.ownerID);

    final user = await getUserQuery.fetchOne();
    newClient.owner = user;

    final addClientQuery = Query<Client>(context)..values = newClient;

    return Response.ok(await addClientQuery.insert());
  }

  @Operation.put('clientID')
  Future<Response> modifyClient(
    @Bind.path('clientID') int id,
    @Bind.body() Client client,
  ) async {
    final modifyClientQuery = Query<Client>(context)
      ..where((c) => c.owner.id).equalTo(request.authorization.ownerID)
      ..where((c) => c.id).equalTo(id)
      ..values = client;

    return Response.ok(await modifyClientQuery.updateOne());
  }

  @Operation.delete('clientID')
  Future<Response> deleteClient(@Bind.path('clientID') int id) async {
    final deleteClientQuery = Query<Client>(context)
      ..where((c) => c.owner.id).equalTo(request.authorization.ownerID)
      ..where((c) => c.id).equalTo(id);

    return Response.ok(await deleteClientQuery.delete());
  }
}
