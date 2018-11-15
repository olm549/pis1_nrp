import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';

import './authentication_service.dart';

@Component(
  selector: 'auth',
  styleUrls: const ['authentication_component.css'],
  templateUrl: 'authentication_component.html',
  directives: [
    coreDirectives,
    formDirectives,
    MaterialInputComponent,
    MaterialButtonComponent,
    MaterialTabPanelComponent,
    MaterialTabComponent,
  ],
  providers: [const ClassProvider(AuthenticationService)],
)
class AuthenticationComponent {
  final AuthenticationService authService;

  String email;
  String password;
  String repeatPassword;

  AuthenticationComponent(this.authService);

  void onTabChange(TabChangeEvent event) {
    email = "";
    password = "";
    repeatPassword = "";
  }

  void signIn() async {
    await authService.signIn(email, password);
  }

  void signUp() async {
    if (password == repeatPassword) {
      await authService.singUp(email, password);
    }
  }
}
