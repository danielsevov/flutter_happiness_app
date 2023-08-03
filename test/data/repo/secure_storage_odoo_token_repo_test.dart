// ignore_for_file: deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happiness_app/data/repositories/secure_storage_odoo_token_repo_impl.dart';
import 'package:happiness_app/domain/repositories/odoo_token_repo.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  String? token;

  setUpAll(() async {
    const MethodChannel('plugins.it_nomads.com/flutter_secure_storage')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'read':
          return token;
        case 'write':
          token = methodCall.arguments['value'] as String?;
          return null;
        case 'delete':
          token = null;
          return null;
        default:
          return null;
      }
    });
  });

  test(
      'OdooTokenRepositoryImplementation calling'
          ' constructor does not cause errors',
      () async {
    final repo = SecureStorageOdooTokenRepositoryImplementation();
    expect(repo, isA<OdooTokenRepository>());
  });

  test(
      'OdooTokenRepositoryImplementation calling getOdooToken()'
          ' when odoo token is not in place returns null odoo token',
      () async {
    final repo = SecureStorageOdooTokenRepositoryImplementation();

    final token = await repo.getOdooToken();

    expect(token, null);
  });

  test(
      'OdooTokenRepositoryImplementation calling getOdooToken()'
          ' when odoo token is already in place returns the stored odoo token',
      () async {
    final repo = SecureStorageOdooTokenRepositoryImplementation();

    await repo.saveToken('testToken');
    final token = await repo.getOdooToken();

    expect(token, 'testToken');
  });

  test(
      'OdooTokenRepositoryImplementation calling saveToken()'
          ' saves the odoo token',
      () async {
    final repo = SecureStorageOdooTokenRepositoryImplementation();

    await repo.saveToken('testToken');

    final retrievedToken = await repo.getOdooToken();

    expect(retrievedToken, 'testToken');
  });

  test(
      'OdooTokenRepositoryImplementation calling clearOdooToken()'
          ' resets the odoo token to null value',
      () async {
    final repo = SecureStorageOdooTokenRepositoryImplementation();

    var retrievedToken = await repo.getOdooToken();

    expect(retrievedToken, 'testToken');

    await repo.clearOdooToken();

    retrievedToken = await repo.getOdooToken();

    expect(retrievedToken, null);
  });
}
