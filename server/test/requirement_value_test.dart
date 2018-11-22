import 'package:server/model/client.dart';
import 'package:server/model/project.dart';
import 'package:server/model/requirement.dart';

import './harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  Project testProject;
  Requirement testRequirement;
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

    testRequirement = Requirement()
      ..id = 1
      ..requirementID = 'R001'
      ..title = 'testtitle'
      ..description = 'testdescription';

    await harness.userAgent.post(
      '/requirements',
      body: {
        'id': testRequirement.id,
        'requirementID': testRequirement.requirementID,
        'title': testRequirement.title,
        'description': testRequirement.description,
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
    'POST /projects/:projectID/requirements/:requirementID/values adds a new requirement value',
    () async {
      final response = await harness.userAgent.post(
        '/projects/${testProject.id}/requirements/${testRequirement.id}/values',
        body: {
          'value': 10.0,
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
          'value': 10.0,
          'project': {
            'id': testProject.id,
          },
          'requirement': {
            'id': testRequirement.id,
          },
          'client': {
            'id': testClient.id,
          },
        },
      );
    },
  );

  test(
    'GET /projects/:projectID/requirements/:requirementID/values/:clientID returns previously added value',
    () async {
      var response = await harness.userAgent.post(
        '/projects/${testProject.id}/requirements/${testRequirement.id}/values',
        body: {
          'value': 10.0,
          'client': {
            'id': testClient.id,
          },
        },
      );

      final createdRequirementValue = response.body.as();

      response = await harness.userAgent.get(
          '/projects/${testProject.id}/requirements/${testRequirement.id}/values/${testClient.id}');

      expectResponse(
        response,
        200,
        body: {
          'id': createdRequirementValue['id'],
          'value': createdRequirementValue['value'],
          'requirement': {
            'id': testRequirement.id,
            'requirementID': testRequirement.requirementID,
            'title': testRequirement.title,
            'description': testRequirement.description,
          },
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
    'GET /projects/:projectID/requirements/:requirementID/values returns all added values',
    () async {
      var response = await harness.userAgent.post(
        '/projects/${testProject.id}/requirements/${testRequirement.id}/values',
        body: {
          'value': 10.0,
          'client': {
            'id': testClient.id,
          },
        },
      );

      final createdRequirementValue = response.body.as();

      response = await harness.userAgent.get(
          '/projects/${testProject.id}/requirements/${testRequirement.id}/values');

      expectResponse(
        response,
        200,
        body: anyElement({
          'id': createdRequirementValue['id'],
          'value': createdRequirementValue['value'],
          'requirement': {
            'id': testRequirement.id,
            'requirementID': testRequirement.requirementID,
            'title': testRequirement.title,
            'description': testRequirement.description,
          },
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
    'PUT /projects/:projectID/requirements/:requirementID/values/:clientID updates a value',
    () async {
      await harness.userAgent.post(
        '/projects/${testProject.id}/requirements/${testRequirement.id}/values',
        body: {
          'client': {
            'id': testClient.id,
          },
        },
      );

      final response = await harness.userAgent.put(
        '/projects/${testProject.id}/requirements/${testRequirement.id}/values/${testClient.id}',
        body: {
          'value': 15.0,
        },
      );

      expectResponse(
        response,
        200,
        body: {
          'id': isNumber,
          'value': 15.0,
          'project': {
            'id': testProject.id,
          },
          'requirement': {
            'id': testRequirement.id,
          },
          'client': {
            'id': testClient.id,
          },
        },
      );
    },
  );

  test(
    'DELETE /projects/:projectID/requirements/:requirementID/values/:clientID removes a value',
    () async {
      await harness.userAgent.post(
        '/projects/${testProject.id}/requirements/${testRequirement.id}/values',
        body: {
          'client': {
            'id': testClient.id,
          },
        },
      );

      final response = await harness.userAgent.delete(
          '/projects/${testProject.id}/requirements/${testRequirement.id}/values/${testClient.id}');

      expectResponse(
        response,
        200,
        body: {
          'rowsDeleted': 1,
        },
      );
    },
  );
}
