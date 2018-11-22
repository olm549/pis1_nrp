import 'package:server/model/project.dart';
import 'package:server/model/requirement.dart';

import './harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  Project testProject;
  Requirement testRequirement;

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
  });

  tearDown(() async {
    await harness.resetData();
  });

  test(
    'POST /projects/:projectID/requirements adds the requirement to the project',
    () async {
      final response = await harness.userAgent.post(
        '/projects/${testProject.id}/requirements',
        body: {
          'requirement': {
            'id': testRequirement.id,
          },
        },
      );

      expectResponse(
        response,
        200,
        body: {
          'id': isNumber,
          'estimatedEffort': 0.0,
          'satisfaction': 0.0,
          'project': {
            'id': testProject.id,
          },
          'requirement': {
            'id': testRequirement.id,
          },
        },
      );
    },
  );

  test(
    'GET /projects/:projectID/requirements/[:requirementID] returns previously added requirement',
    () async {
      var response = await harness.userAgent.post(
        '/projects/${testProject.id}/requirements',
        body: {
          'requirement': {
            'id': testRequirement.id,
          },
        },
      );

      final createdProjectRequirement = response.body.as();

      response = await harness.userAgent.get(
          '/projects/${testProject.id}/requirements/${testRequirement.id}');

      expectResponse(
        response,
        200,
        body: {
          'id': createdProjectRequirement['id'],
          'estimatedEffort': createdProjectRequirement['estimatedEffort'],
          'satisfaction': createdProjectRequirement['satisfaction'],
          'requirement': {
            'id': testRequirement.id,
            'requirementID': testRequirement.requirementID,
            'title': testRequirement.title,
            'description': testRequirement.description,
          },
        },
      );
    },
  );

  test(
    'GET /projects/:projectID/requirements returns all added requirements',
    () async {
      var response = await harness.userAgent.post(
        '/projects/${testProject.id}/requirements',
        body: {
          'requirement': {
            'id': testRequirement.id,
          },
        },
      );

      final createdProjectRequirement = response.body.as();

      response = await harness.userAgent
          .get('/projects/${testProject.id}/requirements');

      expectResponse(
        response,
        200,
        body: anyElement({
          'id': createdProjectRequirement['id'],
          'estimatedEffort': createdProjectRequirement['estimatedEffort'],
          'satisfaction': createdProjectRequirement['satisfaction'],
          'requirement': {
            'id': testRequirement.id,
            'requirementID': testRequirement.requirementID,
            'title': testRequirement.title,
            'description': testRequirement.description,
          },
        }),
      );
    },
  );

  test(
    'PUT /projects/:projectID/requirements/:requirementID updates the values of added requirement',
    () async {
      await harness.userAgent.post(
        '/projects/${testProject.id}/requirements',
        body: {
          'requirement': {
            'id': testRequirement.id,
          },
        },
      );

      final response = await harness.userAgent.put(
        '/projects/${testProject.id}/requirements/${testRequirement.id}',
        body: {
          'estimatedEffort': 20.0,
          'satisfaction': 10.0,
        },
      );

      expectResponse(
        response,
        200,
        body: {
          'id': isNumber,
          'estimatedEffort': 20.0,
          'satisfaction': 10.0,
          'project': {
            'id': testProject.id,
          },
          'requirement': {
            'id': testRequirement.id,
          },
        },
      );
    },
  );

  test(
    'DELETE /projects/:projectID/requirements/:requirementID removes a requirement from a project',
    () async {
      await harness.userAgent.post(
        '/projects/${testProject.id}/requirements',
        body: {
          'requirement': {
            'id': testRequirement.id,
          },
        },
      );

      final response = await harness.userAgent.delete(
          '/projects/${testProject.id}/requirements/${testRequirement.id}');

      expectResponse(
        response,
        200,
        body: {
          'projectRequirementRowsDeleted': 1,
          'requirementValuesRowsDeleted': 0,
        },
      );
    },
  );
}
