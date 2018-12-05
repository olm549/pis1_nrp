import 'package:angular_router/angular_router.dart';

import '../components/authentication/authentication_component.template.dart'
    as authentication_template;
import '../components/projects/projects_component.template.dart'
    as projects_template;
import '../components/clients/clients_component.template.dart'
    as clients_template;
import '../components/requirements/requirements_component.template.dart'
    as requirements_template;
import '../components/project_clients/clients_active_component.template.dart'
    as clients_active_template;
import '../components/project_requirements/requirements_active_component.template.dart'
    as requirements_active_template;
import '../components/requirement_values/requirement_values_component.template.dart'
    as requirement_values_template;

class Paths {
  static final auth = RoutePath(path: 'auth');
  static final projects = RoutePath(path: 'projects');
  static final clients = RoutePath(path: 'clients');
  static final requirements = RoutePath(path: 'requirements');
  static final clients_active = RoutePath(path: 'clients_active');
  static final requirements_active = RoutePath(path: 'requirements_active');
  static final requirement_values = RoutePath(path: 'requirement_values');
}

class Routes {
  static final auth = RouteDefinition(
    routePath: Paths.auth,
    component: authentication_template.AuthenticationComponentNgFactory,
    useAsDefault: true,
  );

  static final projects = RouteDefinition(
    routePath: Paths.projects,
    component: projects_template.ProjectsComponentNgFactory,
  );

  static final clients = RouteDefinition(
    routePath: Paths.clients,
    component: clients_template.ClientsComponentNgFactory,
  );

  static final requirements = RouteDefinition(
    routePath: Paths.requirements,
    component: requirements_template.RequirementsComponentNgFactory,
  );

  static final clients_active = RouteDefinition(
    routePath: Paths.clients_active,
    component: clients_active_template.ClientsComponentNgFactory,
  );

  static final requirements_active = RouteDefinition(
    routePath: Paths.requirements_active,
    component: requirements_active_template.RequirementsComponentNgFactory,
  );

  static final requirement_values = RouteDefinition(
    routePath: Paths.requirement_values,
    component: requirement_values_template.RequirementValuesComponentNgFactory,
  );

  static final all = <RouteDefinition>[
    auth,
    projects,
    clients,
    requirements,
    clients_active,
    requirements_active,
    requirement_values,
  ];
}
