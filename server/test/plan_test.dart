import 'package:server/model/client.dart';
import 'package:server/model/project.dart';
import 'package:server/model/project_client.dart';
import 'package:server/model/project_requirement.dart';
import 'package:server/model/requirement.dart';

import './harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  Project testProject;
  Requirement testRequirement1;
  Requirement testRequirement2;
  Client testClient;

  setUp(() async {
    testProject = Project()
      ..id = 1
      ..projectID = 'P001'
      ..name = 'testname'
      ..description = 'testdescription'
      ..effortLimit = 10;

    await harness.userAgent.post(
      '/projects',
      body: {
        'id': testProject.id,
        'projectID': testProject.projectID,
        'name': testProject.name,
        'description': testProject.description,
        'effortLimit': testProject.effortLimit,
      },
    );

    testRequirement1 = Requirement()
      ..id = 1
      ..requirementID = 'R001'
      ..title = 'testtitle'
      ..description = 'testdescription';

    await harness.userAgent.post(
      '/requirements',
      body: {
        'id': testRequirement1.id,
        'requirementID': testRequirement1.requirementID,
        'title': testRequirement1.title,
        'description': testRequirement1.description,
      },
    );

    testRequirement2 = Requirement()
      ..id = 2
      ..requirementID = 'R002'
      ..title = 'testtitle'
      ..description = 'testdescription';

    await harness.userAgent.post(
      '/requirements',
      body: {
        'id': testRequirement2.id,
        'requirementID': testRequirement2.requirementID,
        'title': testRequirement2.title,
        'description': testRequirement2.description,
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
    'POST /projects/:projectID/plan returns planned requirements',
    () async {
      await harness.userAgent.post(
        '/projects/${testProject.id}/clients',
        body: {
          'weight': 10,
          'client': {
            'id': testClient.id,
          },
        },
      );

      await harness.userAgent.post(
        '/projects/${testProject.id}/requirements',
        body: {
          'estimatedEffort': 10,
          'requirement': {
            'id': testRequirement1.id,
          },
        },
      );

      await harness.userAgent.post(
        '/projects/${testProject.id}/requirements',
        body: {
          'estimatedEffort': 20,
          'requirement': {
            'id': testRequirement2.id,
          },
        },
      );

      await harness.userAgent.put(
        '/projects/${testProject.id}/requirements/${testRequirement1.id}/values/${testClient.id}',
        body: {
          'value': 10.0,
        },
      );

      await harness.userAgent.put(
        '/projects/${testProject.id}/requirements/${testRequirement2.id}/values/${testClient.id}',
        body: {
          'value': 20.0,
        },
      );

      final response =
          await harness.userAgent.post('/projects/${testProject.id}/plan');

      expectResponse(response, 200, body: hasLength(1));
      expectResponse(
        response,
        200,
        body: anyElement({
          'id': isNumber,
          'estimatedEffort': 10,
          'satisfaction': 100,
          'requirement': {
            'id': testRequirement1.id,
          },
        }),
      );
    },
  );
}
