import 'package:server/model/client.dart';

import './harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  tearDown(() async {
    await harness.resetData();
  });

  test('POST /clients creates a new client', () async {
    final testClient = Client()
      ..clientID = 'C001'
      ..name = 'testname'
      ..surname = 'testsurname';

    final response = await harness.userAgent.post(
      '/clients',
      body: {
        'clientID': testClient.clientID,
        'name': testClient.name,
        'surname': testClient.surname,
      },
    );

    expectResponse(
      response,
      200,
      body: {
        'id': isNumber,
        'clientID': testClient.clientID,
        'name': testClient.name,
        'surname': testClient.surname,
        'owner': {
          'id': isNumber,
        },
      },
    );
  });

  test('GET /clients/:id returns previously created client', () async {
    var response = await harness.userAgent.post(
      '/clients',
      body: {
        'clientID': 'C001',
        'name': 'testname',
        'surname': 'testsurname',
      },
    );

    final createdClient = response.body.as();

    response = await harness.userAgent.get('/clients/${createdClient['id']}');

    expectResponse(
      response,
      200,
      body: {
        'id': createdClient['id'],
        'clientID': createdClient['clientID'],
        'name': createdClient['name'],
        'surname': createdClient['surname'],
        'owner': createdClient['owner'],
      },
    );
  });

  test('GET /clients returns all created clients', () async {
    var response = await harness.userAgent.post(
      '/clients',
      body: {
        'clientID': 'C001',
        'name': 'testname',
        'surname': 'testsurname',
      },
    );

    final createdClient = response.body.as();

    response = await harness.userAgent.get('/clients');

    expectResponse(
      response,
      200,
      body: anyElement({
        'id': createdClient['id'],
        'clientID': createdClient['clientID'],
        'name': createdClient['name'],
        'surname': createdClient['surname'],
        'owner': createdClient['owner'],
      }),
    );
  });

  test('PUT /clients/:id updates a client', () async {
    final testClient = Client()
      ..clientID = 'C001'
      ..name = 'testname'
      ..surname = 'testsurname';

    var response = await harness.userAgent.post(
      '/clients',
      body: {
        'clientID': testClient.clientID,
        'name': testClient.name,
        'surname': testClient.surname,
      },
    );

    final int id = response.body.as()['id'];

    testClient.name = 'modifiedname';
    testClient.surname = 'modifiedsurname';

    response = await harness.userAgent.put(
      '/clients/$id',
      body: {
        'name': testClient.name,
        'surname': testClient.surname,
      },
    );

    expectResponse(
      response,
      200,
      body: {
        'id': id,
        'clientID': testClient.clientID,
        'name': testClient.name,
        'surname': testClient.surname,
        'owner': {
          'id': isNumber,
        },
      },
    );
  });

  test('DELETE /clients/:id deletes a client', () async {
    var response = await harness.userAgent.post(
      '/clients',
      body: {
        'clientID': 'C001',
        'name': 'testname',
        'surname': 'testsurname',
      },
    );

    final int id = response.body.as()['id'];

    response = await harness.userAgent.delete('/clients/$id');

    expectResponse(
      response,
      200,
      body: {
        'rowsDeleted': 1,
      },
    );
  });
}
