import 'package:server/model/requirement.dart';

import './harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  tearDown(() async {
    await harness.resetData();
  });

  test('POST /requirements creates a new requirement', () async {
    final testRequirement = Requirement()
      ..requirementID = 'R001'
      ..title = 'testtitle'
      ..description = 'testdescription';

    final response = await harness.userAgent.post(
      '/requirements',
      body: {
        'requirementID': testRequirement.requirementID,
        'title': testRequirement.title,
        'description': testRequirement.description,
      },
    );

    expectResponse(
      response,
      200,
      body: {
        'id': isNumber,
        'requirementID': testRequirement.requirementID,
        'title': testRequirement.title,
        'description': testRequirement.description,
      },
    );
  });

  test('GET /requirements/:id returns previously created requirement',
      () async {
    var response = await harness.userAgent.post(
      '/requirements',
      body: {
        'requirementID': 'R001',
        'title': 'testtitle',
        'description': 'testdescription',
      },
    );

    final createdRequirement = response.body.as();

    response = await harness.userAgent
        .get('/requirements/${createdRequirement['id']}');

    expectResponse(
      response,
      200,
      body: {
        'id': createdRequirement['id'],
        'requirementID': createdRequirement['requirementID'],
        'title': createdRequirement['title'],
        'description': createdRequirement['description'],
        'projects': [],
      },
    );
  });

  test('GET /requirements returns all created requirements', () async {
    var response = await harness.userAgent.post(
      '/requirements',
      body: {
        'requirementID': 'R001',
        'title': 'testtitle',
        'description': 'testdescription',
      },
    );

    final createdRequirement = response.body.as();

    response = await harness.userAgent.get('/requirements');

    expectResponse(
      response,
      200,
      body: anyElement({
        'id': createdRequirement['id'],
        'requirementID': createdRequirement['requirementID'],
        'title': createdRequirement['title'],
        'description': createdRequirement['description'],
      }),
    );
  });

  test('PUT /requirements/:id updates a requirement', () async {
    final testRequirement = Requirement()
      ..requirementID = 'R001'
      ..title = 'testtitle'
      ..description = 'testdescription';

    var response = await harness.userAgent.post(
      '/requirements',
      body: {
        'requirementID': testRequirement.requirementID,
        'title': testRequirement.title,
        'description': testRequirement.description,
      },
    );

    final int id = response.body.as()['id'];

    testRequirement.title = 'modifiedtitle';
    testRequirement.description = 'modifieddescription';

    response = await harness.userAgent.put(
      '/requirements/$id',
      body: {
        'title': testRequirement.title,
        'description': testRequirement.description,
      },
    );

    expectResponse(
      response,
      200,
      body: {
        'id': id,
        'requirementID': testRequirement.requirementID,
        'title': testRequirement.title,
        'description': testRequirement.description,
      },
    );
  });

  test('DELETE /requirements/:id deletes a requirement', () async {
    var response = await harness.userAgent.post(
      '/requirements',
      body: {
        'requirementID': 'R001',
        'title': 'testtitle',
        'description': 'testdescription',
      },
    );

    final int id = response.body.as()['id'];

    response = await harness.userAgent.delete('/requirements/$id');

    expectResponse(
      response,
      200,
      body: {
        'rowsDeleted': 1,
      },
    );
  });
}
