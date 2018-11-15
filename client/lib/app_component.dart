import 'package:angular/angular.dart';

import './src/authentication/authentication_component.dart';
import './src/dashboard/dashboard_component.dart';

// AngularDart info: https://webdev.dartlang.org/angular
// Components info: https://webdev.dartlang.org/components

@Component(
  selector: 'nrp-app',
  styleUrls: ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: [
    coreDirectives,
    AuthenticationComponent,
    DashboardComponent,
  ],
)
class AppComponent {}
