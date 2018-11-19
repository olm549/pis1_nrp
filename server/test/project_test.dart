import 'package:server/model/project.dart';

import './harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  tearDown(() async {
    await harness.resetData();
  });

  test('POST /projects creates a new project', () async {
    final testProject = Project()
      ..projectID = 'P001'
      ..name = 'testname'
      ..description = 'testdescription';

    final response = await harness.userAgent.post(
      '/projects',
      body: {
        'projectID': testProject.projectID,
        'name': testProject.name,
        'description': testProject.description,
      },
    );

    expectResponse(
      response,
      200,
      body: {
        'id': isNumber,
        'projectID': testProject.projectID,
        'name': testProject.name,
        'description': testProject.description,
        'effortLimit': 0.0,
        'active': false,
        'owner': {
          'id': isNumber,
        },
      },
    );
  });

  test('GET /projects/:id returns previously created project', () async {
    var response = await harness.userAgent.post(
      '/projects',
      body: {
        'projectID': 'P001',
        'name': 'testname',
        'description': 'testdescription',
      },
    );

    final createdProject = response.body.as();

    response = await harness.userAgent.get('/projects/${createdProject['id']}');

    expectResponse(
      response,
      200,
      body: {
        'id': createdProject['id'],
        'projectID': createdProject['projectID'],
        'name': createdProject['name'],
        'description': createdProject['description'],
        'effortLimit': 0.0,
        'active': false,
        'owner': createdProject['owner'],
      },
    );
  });

  test('GET /projects returns all created projects', () async {
    var response = await harness.userAgent.post(
      '/projects',
      body: {
        'projectID': 'P001',
        'name': 'testname',
        'description': 'testdescription',
      },
    );

    final createdProject = response.body.as();

    response = await harness.userAgent.get('/projects');

    expectResponse(
      response,
      200,
      body: anyElement({
        'id': createdProject['id'],
        'projectID': createdProject['projectID'],
        'name': createdProject['name'],
        'description': createdProject['description'],
        'effortLimit': 0.0,
        'active': false,
        'owner': createdProject['owner'],
      }),
    );
  });

  test('GET /projects?active=true returns active project', () async {
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

    response = await harness.userAgent.get('/projects?active=true');

    expectResponse(
      response,
      200,
      body: {
        'id': createdProject['id'],
        'projectID': createdProject['projectID'],
        'name': createdProject['name'],
        'description': createdProject['description'],
        'effortLimit': createdProject['effortLimit'],
        'active': isTrue,
        'owner': createdProject['owner'],
      },
    );
  });

  test('GET /projects?active=true returns a 404 response', () async {
    await harness.userAgent.post(
      '/projects',
      body: {
        'projectID': 'P001',
        'name': 'testname',
        'description': 'testdescription',
      },
    );

    final response = await harness.userAgent.get('/projects?active=true');

    expectResponse(response, 404);
  });

  test('PUT /projects/:id updates a project', () async {
    final testProject = Project()
      ..projectID = 'P001'
      ..name = 'testname'
      ..description = 'testdescription';

    var response = await harness.userAgent.post(
      '/projects',
      body: {
        'projectID': testProject.projectID,
        'name': testProject.name,
        'description': testProject.description,
      },
    );

    final int id = response.body.as()['id'];

    testProject.effortLimit = 20.0;
    testProject.active = true;

    response = await harness.userAgent.put(
      '/projects/$id',
      body: {
        'effortLimit': testProject.effortLimit,
        'active': testProject.active,
      },
    );

    expectResponse(
      response,
      200,
      body: {
        'id': id,
        'projectID': testProject.projectID,
        'name': testProject.name,
        'description': testProject.description,
        'effortLimit': testProject.effortLimit,
        'active': testProject.active,
        'owner': {
          'id': isNumber,
        },
      },
    );
  });

  test('DELETE /projects/:id deletes a project', () async {
    var response = await harness.userAgent.post(
      '/projects',
      body: {
        'projectID': 'P001',
        'name': 'testname',
        'description': 'testdescription',
      },
    );

    final int id = response.body.as()['id'];

    response = await harness.userAgent.delete('/projects/$id');

    expectResponse(
      response,
      200,
      body: {
        'rowsDeleted': 1,
      },
    );
  });
}
