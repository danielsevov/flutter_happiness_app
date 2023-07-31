// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:happiness_app/domain/repositories/odoo_token_repo.dart';

class SecureStorageOdooTokenRepositoryImplementation
    implements OdooTokenRepository {

  SecureStorageOdooTokenRepositoryImplementation();

  final secureStorage = const FlutterSecureStorage();
  final odooTokenKey = 'odooToken';

  @override
  Future<void> clearOdooToken() async {
    await secureStorage.delete(key: odooTokenKey);
  }

  @override
  Future<String?> getOdooToken() {
    return secureStorage.read(key: odooTokenKey);
  }

  @override
  Future<void> saveToken(String value) async {
    await secureStorage.write(key: odooTokenKey, value: value);
  }
}
