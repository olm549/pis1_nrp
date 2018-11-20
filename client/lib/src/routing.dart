import 'package:angular_router/angular_router.dart';

import './authentication/authentication_component.template.dart'
    as authentication_template;

class Paths {
  static final auth = RoutePath(path: 'auth');
}

class Routes {
  static final auth = RouteDefinition(
    routePath: Paths.auth,
    component: authentication_template.AuthenticationComponentNgFactory,
    useAsDefault: true,
  );

  static final all = <RouteDefinition>[
    auth,
  ];
}
