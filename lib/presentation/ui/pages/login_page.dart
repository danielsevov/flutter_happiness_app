// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, use_decorated_box, avoid_positional_boolean_parameters, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:happiness_app/domain/repositories/odoo_token_repo.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/ui/kabisa_login_browser.dart';
import 'package:happiness_app/presentation/ui/pages/dashboard_page.dart';
import 'package:happiness_app/presentation/ui/widgets/reusable/dialogs/custom_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../state_management/providers.dart';

/// The log in page allows the user to log in with Odoo.
class LogInPage extends ConsumerStatefulWidget {
  const LogInPage(
      {super.key,
      required this.odooTokenRepository,
      required this.initializeDatasource,});

  final OdooTokenRepository odooTokenRepository;
  final Future<void> Function(String token, WidgetRef ref) initializeDatasource;

  @override
  ConsumerState<LogInPage> createState() => LogInPageState();
}

class LogInPageState extends ConsumerState<LogInPage> {
  bool isLoading = false;
  bool isFirstTime = true;

  void setInProgress(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Future<bool> hasAgreedToPrivacyPolicy() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('agreedToPrivacyPolicy') ?? false;
  }

  Future<void> setAgreedToPrivacyPolicy(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('agreedToPrivacyPolicy', value);
  }

  Future<void> autoLogIn(BuildContext context) async {
    setInProgress(true);

    final token = await widget.odooTokenRepository.getOdooToken();
    try {
      await widget.initializeDatasource(token!, ref);

      if (!context.mounted) return;
      Helper.replacePageWithSlideAnimation(context, DashboardPage(
        odooTokenRepository:
        ref.watch(odooRepoProvider),
        introspectionPresenter:
        ref.watch(historyPresenterProvider),
        settingsPresenter:
        ref.watch(settingsPresenterProvider),
        userDetails:
        ref.watch(userDetailsStateProvider,
        ),
      ),);
    } catch (e) {
      setInProgress(false);
      await widget.odooTokenRepository.clearOdooToken();
    }
  }

  @override
  void initState() {
    if (isFirstTime) {
      isFirstTime = false;
      autoLogIn(context);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo
                Hero(
                  tag: 'logoImage',
                  key: const Key('logoImage'),
                  child: Image.asset(
                    'assets/images/round_logo.png',
                    width: constraints.maxHeight < constraints.maxWidth
                        ? constraints.maxHeight / 2.5
                        : constraints.maxWidth / 2,
                  ),
                ),
                SizedBox(
                  height: constraints.maxHeight / 10,
                ),
                SizedBox(
                  width: constraints.maxWidth - 50,
                  child: Text(
                    localizations.pleaseLogIn,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.background,
                          fontSize: Helper.getNormalTextSize(constraints),
                        ),
                  ),
                ),
                const SizedBox(height: 25),

                // log in button
                if (isLoading)
                  Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.background,
                    ),
                  )
                else
                  FloatingActionButton.extended(
                    heroTag: 'logInButton',
                    onPressed: () async {
                      final hasAgreed = await hasAgreedToPrivacyPolicy();

                      if (!context.mounted) return;
                      final bool? result;
                      if (!hasAgreed) {
                        result = await showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: MaterialLocalizations.of(context)
                              .modalBarrierDismissLabel,
                          barrierColor: Colors.black45,
                          transitionDuration: const Duration(milliseconds: 300),
                          transitionBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation,
                              Widget child) {
                            // transition to use
                            return ScaleTransition(
                              scale: animation,
                              child: child,
                            );
                          },
                          pageBuilder: (BuildContext buildContext,
                              Animation<double> animation, Animation<double> secondaryAnimation) {
                            return CustomDialog(
                              title: localizations.dataPrivacyPolicy,
                              bodyText: localizations.privacyPolicy,
                              confirm: () async {
                                Navigator.of(context).pop(true);
                                await setAgreedToPrivacyPolicy(true);
                              },
                              cancel: () {
                                Navigator.of(context).pop(false);
                              },
                              constraints: constraints,
                            );
                          },
                        );
                      } else {
                        result = true;
                      }

                      if (result != null && result) {
                        if (!context.mounted) return;
                        final browser = KabisaLoginBrowser(
                          () {
                            Helper.replacePageWithSlideAnimation(
                              context,
                              DashboardPage(
                                odooTokenRepository: ref.watch(odooRepoProvider),
                                introspectionPresenter: ref.watch(historyPresenterProvider),
                                settingsPresenter: ref.watch(settingsPresenterProvider),
                                userDetails: ref.watch(userDetailsStateProvider),
                              ),
                            );
                          },
                          (String token) async {
                            await ref.watch(initOdooMethodProvider,).call(token, ref,);
                          },
                          Logger(),
                        );
                        final settings = InAppBrowserClassSettings(
                          webViewSettings: InAppWebViewSettings(
                            userAgent: "Mozilla/5.0 (Linux; Android 10; Pixel 3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.77 Mobile Safari/537.36"
                          ),
                          browserSettings: InAppBrowserSettings(
                            windowType: Theme.of(context).platform ==
                                    TargetPlatform.macOS
                                ? WindowType.TABBED
                                : null,
                            hideUrlBar: true,
                          ),
                        );

                        await browser.openUrlRequest(
                          settings: settings,
                          urlRequest: URLRequest(
                            url: WebUri(
                                'https://portal.kabisa.nl/web/login',),
                          ),
                        );
                      }
                    },
                    backgroundColor: Theme.of(context).colorScheme.background,
                    label: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        localizations.login,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: Helper.getButtonTextSize(constraints),
                            ),
                      ),
                    ),
                    icon: Icon(
                      Icons.login,
                      color: Theme.of(context).colorScheme.primary,
                      size: Helper.getIconSize(constraints),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
