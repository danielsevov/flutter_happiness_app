// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// Web browser nested within the application, which allows
/// the odoo login page to be shown to the user for log in
/// and then the sessionId is extracted and used for authentication.
class LoginBrowser extends InAppBrowser {
  LoginBrowser(this.navigateToDashboard, this.initFunction, this.logger,
      {CookieManager? cookieManager,})
      : cookieManager = cookieManager ?? CookieManager.instance();

  final void Function() navigateToDashboard;
  Future<void> Function(String) initFunction;
  final CookieManager cookieManager;
  final Logger logger;

  @override
  Future<dynamic> onBrowserCreated() async {
    logger.log('Browser Created!');
    super.onBrowserCreated();
  }

  @override
  Future<dynamic> onLoadStart(WebUri? url) async {
    logger.log('Started $url');
    super.onLoadStart(url);
  }

  @override
  Future<dynamic> onLoadStop(WebUri? url) async {
    logger.log('Stopped $url');
    super.onLoadStop(url);
  }

  @override
  void onProgressChanged(int progress) {
    logger.log('Progress: >>>> $progress');
    super.onProgressChanged(progress);
  }

  @override
  Future<void> onUpdateVisitedHistory(WebUri? url, bool? isReload) async {
    // if log in was successful
    if (url != null &&
        url.toString() == ('https://testhappinessapp.odoo.com/web')) {
      // extract the session id cookie
      final cookies = await cookieManager.getCookies(url: url);
      final mainCookie =
          cookies.firstWhere((element) => element.name.contains('session_id'));

      // initialize the odoo datasource connector with the sessionId
      await initFunction.call(mainCookie.value as String,);

      // close the in app browser
      await close();

      // navigate to dashboard
      navigateToDashboard();
    }
  }

  @override
  void onExit() {
    logger.log('Browser closed!');
    super.onExit();
  }
}

/// Used for logging messages.
class Logger {
  // A list to store the logged messages.
  final List<String> logs = [];

  // A method called `log` which takes a string [message] as input and adds it to the [logs] list.
  void log(String message) {
    logs.add(message);
  }
}
