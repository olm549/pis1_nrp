import '../model/project.dart';
import '../model/project_client.dart';
import '../model/project_requirement.dart';
import '../model/requirement_value.dart';

import '../server.dart';

class PlanController extends ResourceController {
  PlanController(this.context);

  ManagedContext context;

  @Operation.post('projectID')
  Future<Response> getPlan(@Bind.path('projectID') int projectID) async {
    // Obtener el proyecto.
    final getProjectQuery = Query<Project>(context)
      ..where((p) => p.id).equalTo(projectID);

    final project = await getProjectQuery.fetchOne();

    // Obtener todos los requisitos.
    final getAllProjectRequirementsQuery = Query<ProjectRequirement>(context)
      ..where((pr) => pr.project.id).equalTo(projectID)
      ..returningProperties((pr) => [
            pr.id,
            pr.estimatedEffort,
            pr.satisfaction,
            pr.requirement,
          ]);

    final projectRequirements = await getAllProjectRequirementsQuery.fetch();

    // Obtener todos los clientes.
    final getAllProjectClientsQuery = Query<ProjectClient>(context)
      ..where((pc) => pc.project.id).equalTo(projectID)
      ..returningProperties((pc) => [pc.id, pc.weight, pc.client]);

    final projectClients = await getAllProjectClientsQuery.fetch();

    // Cálculo de la satisfacción de los requisitos.
    for (ProjectRequirement pr in projectRequirements) {
      double satisfaction = 0;

      for (ProjectClient pc in projectClients) {
        final getRequirementValueQuery = Query<RequirementValue>(context)
          ..where((rv) => rv.project.id).equalTo(projectID)
          ..where((rv) => rv.requirement.id).equalTo(pr.requirement.id)
          ..where((rv) => rv.client.id).equalTo(pc.client.id);

        final requirementValue = await getRequirementValueQuery.fetchOne();

        satisfaction += pc.weight * requirementValue.value;
      }

      print('New satisfaction $satisfaction');

      pr.satisfaction = satisfaction;

      final updateSatisfactionQuery = Query<ProjectRequirement>(context)
        ..where((pr) => pr.id).equalTo(pr.id)
        ..values = pr;

      await updateSatisfactionQuery.updateOne();
    }

    // Ordenar la lista de requisitos según esfuerzo.
    projectRequirements.sort((pr1, pr2) {
      if (pr1.satisfaction < pr2.satisfaction) {
        return 1;
      } else if (pr1.satisfaction > pr2.satisfaction) {
        return -1;
      } else {
        return 0;
      }
    });

    double accEffort = 0;
    final List<ProjectRequirement> results = [];

    print('Límite de esfuerzo ${project.effortLimit}');

    for (ProjectRequirement pr in projectRequirements) {
      print('Esfuerzo acumulado $accEffort');

      print('Estimated effort ${pr.estimatedEffort}');
      print('Satisfaction: ${pr.satisfaction}');

      if (pr.estimatedEffort > (project.effortLimit - accEffort)) {
        continue;
      } else {
        accEffort += pr.estimatedEffort;
        results.add(pr);
      }
    }

    return Response.ok(results);
  }
}
