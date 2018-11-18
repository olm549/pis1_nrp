import './harness/app.dart';

void main() {
  final harness = Harness()..install();

  tearDown(() async {
    await harness.resetData();
  });

  test('POST /register creates a new user', () async {
    final response = await harness.publicAgent.post(
      '/register',
      body: {
        'username': 'registertest@test.com',
        'password': 'foobar123',
      },
    );

    expectResponse(
      response,
      200,
      body: {
        'id': greaterThan(0),
        'username': 'registertest@test.com',
      },
    );
  });

  test('POST /register without a username fails', () async {
    final response = await harness.publicAgent.post(
      '/register',
      body: {
        'password': 'foobar123',
      },
    );

    expectResponse(
      response,
      400,
      body: {
        'errorMsg': 'Missing user or password',
      },
    );
  });

  test('POST /register without a password fails', () async {
    final response = await harness.publicAgent.post(
      '/register',
      body: {
        'username': 'user@test.com',
      },
    );

    expectResponse(
      response,
      400,
      body: {
        'errorMsg': 'Missing user or password',
      },
    );
  });
}
