import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';

import './src/routing.dart';
import './src/user_service.dart';

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
  providers: [const ClassProvider(UserService)],
)
class AppComponent {
  final UserService userService;
  final Router router;

  AppComponent(this.userService, this.router);

  void signOut() {
    userService.logOutUser();

    router.navigateByUrl(Paths.auth.toUrl());
  }
}
