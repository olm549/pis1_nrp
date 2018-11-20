import 'package:angular_router/angular_router.dart';

import './authentication/authentication_component.template.dart'
    as authentication_template;
import './projects/projects_component.template.dart' as projects_template;
import './clients/clients_component.template.dart' as clients_template;
import './requirements/requirements_component.template.dart'
    as requirements_template;

class Paths {
  static final auth = RoutePath(path: 'auth');
  static final projects = RoutePath(path: 'projects');
  static final clients = RoutePath(path: 'clients');
  static final requirements = RoutePath(path: 'requirements');
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

  static final all = <RouteDefinition>[
    auth,
    projects,
    clients,
    requirements,
  ];
}
