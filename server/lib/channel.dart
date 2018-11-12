import './controller/client_controller.dart';
import './controller/project_client_controller.dart';
import './controller/project_controller.dart';
import './controller/project_requirement_controller.dart';
import './controller/register_controller.dart';
import './controller/requirement_controller.dart';
import './controller/requirement_value_controller.dart';

import './model/user.dart';

import './nrp_server.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
class NrpServerChannel extends ApplicationChannel {
  ManagedContext context;
  AuthServer authServer;

  /// Initialize services in this method.
  ///
  /// Implement this method to initialize services, read values from [options]
  /// and any other initialization required before constructing [entryPoint].
  ///
  /// This method is invoked prior to [entryPoint] being accessed.
  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    final config = NrpServerConfiguration(options.configurationFilePath);
    context = contextWithConnectionInfo(config.database);

    final authStorage = ManagedAuthDelegate<User>(context);
    authServer = AuthServer(authStorage);
  }

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint {
    final router = Router();

    // Authenticate a user
    router.route('/auth/token').link(() => AuthController(authServer));

    // Create a new user
    router
        .route('/register')
        .link(() => Authorizer.basic(authServer))
        .link(() => RegisterController(context, authServer));

    // Access user's projects
    router
        .route('/projects/[:projectID]')
        .link(() => Authorizer.bearer(authServer))
        .link(() => ProjectController(context));

    // Access project's assigned requirements
    router
        .route('/projects/:projectID/requirements/[:requirementID]')
        .link(() => Authorizer.bearer(authServer))
        .link(() => ProjectRequirementController(context));

    // Access project's client values for a requirement
    router
        .route(
            '/projects/:projectID/requirements/:requirementID/values/[:clientID]')
        .link(() => Authorizer.bearer(authServer))
        .link(() => RequirementValueController(context));

    // Access project's assigned clients
    router
        .route('/projects/:projectID/clients/[:clientID]')
        .link(() => Authorizer.bearer(authServer))
        .link(() => ProjectClientController(context));

    // Access user's requirements
    router
        .route('/requirements/[:requirementID]')
        .link(() => Authorizer.bearer(authServer))
        .link(() => RequirementController(context));

    // Access user's clients
    router
        .route('/clients/[:clientID]')
        .link(() => Authorizer.bearer(authServer))
        .link(() => ClientController(context));

    return router;
  }

  /*
   * Helper methods
   */

  ManagedContext contextWithConnectionInfo(
      DatabaseConfiguration connectionInfo) {
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final psc = PostgreSQLPersistentStore(
        connectionInfo.username,
        connectionInfo.password,
        connectionInfo.host,
        connectionInfo.port,
        connectionInfo.databaseName);

    return ManagedContext(dataModel, psc);
  }
}

/// An instance of this class reads values from a configuration
/// file specific to this application.
///
/// Configuration files must have key-value for the properties in this class.
/// For more documentation on configuration files, see https://aqueduct.io/docs/configure/ and
/// https://pub.dartlang.org/packages/safe_config.
class NrpServerConfiguration extends Configuration {
  NrpServerConfiguration(String fileName) : super.fromFile(File(fileName));

  DatabaseConfiguration database;
}
