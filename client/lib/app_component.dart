import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';

import './src/utils/routing.dart';

import './src/services/user_service.dart';
import './src/services/http_service.dart';

@Component(
  selector: 'nrp-app',
  styleUrls: [
    'package:angular_components/app_layout/layout.scss.css',
    'app_component.css',
  ],
  templateUrl: 'app_component.html',
  directives: [
    routerDirectives,
    coreDirectives,
    DeferredContentDirective,
    MaterialPersistentDrawerDirective,
    MaterialListComponent,
    MaterialListItemComponent,
    MaterialButtonComponent,
    MaterialIconComponent,
  ],
  exports: [Paths, Routes],
  providers: [
    const ClassProvider(UserService),
    const ClassProvider(HttpService),
  ],
)
class AppComponent {
  final UserService userService;
  final Router _router;

  AppComponent(this.userService, this._router);

  void signOut() {
    userService.logOutUser();

    _router.navigateByUrl(Paths.auth.toUrl());
  }
}
