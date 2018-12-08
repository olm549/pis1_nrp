import 'package:server/model/client.dart';
import 'package:server/model/project.dart';

import './harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  Project testProject;
  Client testClient;

  setUp(() async {
    testProject = Project()
      ..id = 1
      ..projectID = 'P001'
      ..name = 'testname'
      ..description = 'testdescription';

    await harness.userAgent.post(
      '/projects',
      body: {
        'id': testProject.id,
        'projectID': testProject.projectID,
        'name': testProject.name,
        'description': testProject.description,
      },
    );

    testClient = Client()
      ..id = 1
      ..clientID = 'C001'
      ..name = 'testname'
      ..surname = 'testsurname';

    await harness.userAgent.post(
      '/clients',
      body: {
        'id': testClient.id,
        'clientID': testClient.clientID,
        'name': testClient.name,
        'surname': testClient.surname,
      },
    );
  });

  tearDown(() async {
    await harness.resetData();
  });

  test(
    'POST /projects/:projectID/clients adds the client to the project',
    () async {
      final response = await harness.userAgent.post(
        '/projects/${testProject.id}/clients',
        body: {
          'client': {
            'id': testClient.id,
          },
        },
      );

      expectResponse(
        response,
        200,
        body: {
          'id': isNumber,
          'weight': 0.0,
          'project': {
            'id': testProject.id,
          },
          'client': {
            'id': testClient.id,
          },
        },
      );
    },
  );

  test('POST /projects/:projectID/clients returns 409 response', () async {
    await harness.userAgent.post(
      '/projects/${testProject.id}/clients',
      body: {
        'client': {
          'id': testClient.id,
        },
      },
    );

    final response = await harness.userAgent.post(
      '/projects/${testProject.id}/clients',
      body: {
        'client': {
          'id': testClient.id,
        },
      },
    );

    expectResponse(response, 409);
  });

  test(
    'GET /projects/:projectID/clients/[:clientID] returns previously added client',
    () async {
      var response = await harness.userAgent.post(
        '/projects/${testProject.id}/clients',
        body: {
          'client': {
            'id': testClient.id,
          },
        },
      );

      final createdProjectClient = response.body.as();

      response = await harness.userAgent
          .get('/projects/${testProject.id}/clients/${testClient.id}');

      expectResponse(
        response,
        200,
        body: {
          'id': createdProjectClient['id'],
          'weight': createdProjectClient['weight'],
          'client': {
            'id': testClient.id,
            'clientID': testClient.clientID,
            'name': testClient.name,
            'surname': testClient.surname,
          },
        },
      );
    },
  );

  test(
    'GET /projects/:projectID/clients returns all added clients',
    () async {
      var response = await harness.userAgent.post(
        '/projects/${testProject.id}/clients',
        body: {
          'client': {
            'id': testClient.id,
          },
        },
      );

      final createdProjectClient = response.body.as();

      response =
          await harness.userAgent.get('/projects/${testProject.id}/clients');

      expectResponse(
        response,
        200,
        body: anyElement({
          'id': createdProjectClient['id'],
          'weight': createdProjectClient['weight'],
          'client': {
            'id': testClient.id,
            'clientID': testClient.clientID,
            'name': testClient.name,
            'surname': testClient.surname,
          },
        }),
      );
    },
  );

  test(
    'PUT /projects/:projectID/clients/:clientID updates the values of added client',
    () async {
      await harness.userAgent.post(
        '/projects/${testProject.id}/clients',
        body: {
          'client': {
            'id': testClient.id,
          },
        },
      );

      final response = await harness.userAgent.put(
        '/projects/${testProject.id}/clients/${testClient.id}',
        body: {
          'weight': 20.0,
        },
      );

      expectResponse(
        response,
        200,
        body: {
          'id': isNumber,
          'weight': 20.0,
          'project': {
            'id': testProject.id,
          },
          'client': {
            'id': testClient.id,
          },
        },
      );
    },
  );

  test(
    'DELETE /projects/:projectID/clients/:clientID removes a client from a project',
    () async {
      await harness.userAgent.post(
        '/projects/${testProject.id}/clients',
        body: {
          'client': {
            'id': testClient.id,
          },
        },
      );

      final response = await harness.userAgent
          .delete('/projects/${testProject.id}/clients/${testClient.id}');

      expectResponse(
        response,
        200,
        body: {
          'projectClientRowsDeleted': 1,
          'requirementValuesRowsDeleted': 0,
        },
      );
    },
  );
}
