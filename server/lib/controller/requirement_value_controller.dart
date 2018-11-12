import '../model/client.dart';
import '../model/project.dart';
import '../model/project_requirement_client.dart';
import '../model/requirement.dart';

import '../nrp_server.dart';

class RequirementValueController extends ResourceController {
  ManagedContext context;

  RequirementValueController(this.context);

  @Operation.get('projectID', 'requirementID')
  Future<Response> getRequirementValues(
    @Bind.path('projectID') int projectID,
    @Bind.path('requirementID') int requirementID,
  ) async {
    final getRequirementValuesQuery = Query<ProjectRequirementClient>(context)
      ..join(object: (prc) => prc.client)
      ..where((prc) => prc.project.id).equalTo(projectID)
      ..where((prc) => prc.requirement.id).equalTo(requirementID);

    // TODO: Add pagination.

    return Response.ok(await getRequirementValuesQuery.fetch());
  }

  @Operation.post('projectID', 'requirementID')
  Future<Response> addRequirementValue(
    @Bind.path('projectID') int projectID,
    @Bind.path('requirementID') int requirementID,
    @Bind.body() Map content,
  ) async {
    final getProjectQuery = Query<Project>(context)
      ..where((p) => p.id).equalTo(projectID);

    final getRequirementQuery = Query<Requirement>(context)
      ..where((r) => r.id).equalTo(requirementID);

    final getClientQuery = Query<Client>(context)
      ..where((c) => c.id)
          .equalTo(int.tryParse(content['clientID'].toString()));

    final project = await getProjectQuery.fetchOne();
    final requirement = await getRequirementQuery.fetchOne();
    final client = await getClientQuery.fetchOne();

    final addRequirementValueQuery = Query<ProjectRequirementClient>(context)
      ..values.project = project
      ..values.requirement = requirement
      ..values.client = client
      ..values.value = double.tryParse(content['value'].toString());

    return Response.ok(await addRequirementValueQuery.insert());
  }

  @Operation.put('projectID', 'requirementID', 'clientID')
  Future<Response> modifyRequirementValues(
    @Bind.path('projectID') int projectID,
    @Bind.path('requirementID') int requirementID,
    @Bind.path('clientID') int clientID,
    @Bind.body() Map content,
  ) async {
    final modifyRequirementValueQuery = Query<ProjectRequirementClient>(context)
      ..where((prc) => prc.project.id).equalTo(projectID)
      ..where((prc) => prc.requirement.id).equalTo(requirementID)
      ..where((prc) => prc.client.id).equalTo(clientID)
      ..values.value = double.tryParse(content['value'].toString());

    return Response.ok(await modifyRequirementValueQuery.updateOne());
  }

  @Operation.delete('projectID', 'requirementID', 'clientID')
  Future<Response> deleteRequirementValue(
    @Bind.path('projectID') int projectID,
    @Bind.path('requirementID') int requirementID,
    @Bind.path('clientID') int clientID,
  ) async {
    final deleteRequirementValueQuery = Query<ProjectRequirementClient>(context)
      ..where((prc) => prc.project.id).equalTo(projectID)
      ..where((prc) => prc.requirement.id).equalTo(requirementID)
      ..where((prc) => prc.client.id).equalTo(clientID);

    return Response.ok(await deleteRequirementValueQuery.delete());
  }
}
