// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happiness_app/presentation/ui/kabisa_login_browser.dart';
import 'package:mockito/mockito.dart';

class MockCookieManager extends Mock implements CookieManager {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  void navigateToDashboard() {}

  group('KabisaLoginBr', () {
    test('Constructor should initialize navigateToDashboard and ref', () {
      final logger = Logger();
      final browser = KabisaLoginBrowser(navigateToDashboard, (String token) async {}, logger);

      expect(browser.navigateToDashboard, equals(navigateToDashboard));
    });

    test('onBrowserCreated should log "Browser Created!"', () async {
      final logger = Logger();
      await KabisaLoginBrowser(navigateToDashboard, (String token) async {}, logger)
      .onBrowserCreated();
      expect(logger.logs, contains('Browser Created!'));
    });

    test('onLoadStart should log "Started {url}"', () async {
      final logger = Logger();
      await KabisaLoginBrowser(navigateToDashboard, (String token) async {}, logger)
      .onLoadStart(null);
      expect(logger.logs, contains('Started null'));
    });

    test('onLoadStop should log "Stopped {url}"', () async {
      final logger = Logger();
      await KabisaLoginBrowser(navigateToDashboard, (String token) async {}, logger)
      .onLoadStop(null);
      expect(logger.logs, contains('Stopped null'));
    });

    test('onProgressChanged should log "Progress: >>>> {progress}"', () {
      final logger = Logger();
      KabisaLoginBrowser(navigateToDashboard, (String token) async {}, logger)
          .onProgressChanged(50);
      expect(logger.logs, contains('Progress: >>>> 50'));
    });

    test('onExit should log "Browser closed!"', () {
      final logger = Logger();
      KabisaLoginBrowser(navigateToDashboard, (String token) async {}, logger)
        .onExit();
      expect(logger.logs, contains('Browser closed!'));
    });
  });
}
