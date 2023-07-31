// ignore_for_file: lines_longer_than_80_chars

/// This is an abstract class that defines the contract for te Odoo token repository.
abstract class OdooTokenRepository {
  /// Resets the Odoo token
  Future<void> clearOdooToken();

  /// Saves the Odoo token
  Future<void> saveToken(String value);

  /// Gets the Odoo token
  Future<String?> getOdooToken();
}
