import './harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  tearDown(() async {
    await harness.resetData();
  });

  test('GET /projects/active returns 404 response', () async {
    final response = await harness.userAgent.get('/projects/active');

    expectResponse(response, 404);
  });

  test('GET /projects/active returns active project', () async {
    var response = await harness.userAgent.post(
      '/projects',
      body: {
        'projectID': 'P001',
        'name': 'testname',
        'description': 'testdescription',
        'active': true,
      },
    );

    final createdProject = response.body.as();

    response = await harness.userAgent.get('/projects/active');

    expectResponse(
      response,
      200,
      body: {
        'id': createdProject['id'],
        'projectID': createdProject['projectID'],
        'name': createdProject['name'],
        'description': createdProject['description'],
        'effortLimit': createdProject['effortLimit'],
      },
    );
  });

  test(
    'PUT /projects/active?newID=newID updates active project',
    () async {
      await harness.userAgent.post(
        '/projects',
        body: {
          'projectID': 'P001',
          'name': 'testname',
          'description': 'testdescription',
          'active': true,
        },
      );

      var response = await harness.userAgent.post(
        '/projects',
        body: {
          'projectID': 'P002',
          'name': 'testname2',
          'description': 'testdescription2',
          'active': false,
        },
      );

      final createdProject = response.body.as();

      response = await harness.userAgent.put(
        '/projects/active?newID=${createdProject['id']}',
      );

      expectResponse(
        response,
        200,
        body: {
          'id': createdProject['id'],
          'projectID': createdProject['projectID'],
          'name': createdProject['name'],
          'description': createdProject['description'],
          'effortLimit': createdProject['effortLimit'],
        },
      );

      response = await harness.userAgent.get('/projects/active');

      expectResponse(
        response,
        200,
        body: {
          'id': createdProject['id'],
          'projectID': createdProject['projectID'],
          'name': createdProject['name'],
          'description': createdProject['description'],
          'effortLimit': createdProject['effortLimit'],
        },
      );
    },
  );
}
