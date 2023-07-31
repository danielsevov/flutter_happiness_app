// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, use_named_constants

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happiness_app/presentation/ui/widgets/reusable/dialogs/custom_dialog.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([])
void main() {

  testWidgets('CustomDialog test constructor', (tester) async {
    await tester.runAsync(() async {
      // tests
      final dialog = CustomDialog(title: 'Sign out', bodyText: 'Are you sure you want to sign out?', confirm: (){}, cancel: (){}, constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),);

      final titleFinder = find.text('Sign out');
      final messageFinder = find.text('Are you sure you want to sign out?');
      final iconFinder = find.byIcon(Icons.check_circle);
      final icon2Finder = find.byIcon(Icons.cancel);

      await tester.pumpWidget(MaterialApp(
          title: 'Flutter Demo', home: Scaffold(body: dialog),),);

      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      expect(titleFinder, findsOneWidget);
      expect(messageFinder, findsOneWidget);
      expect(iconFinder, findsOneWidget);
      expect(icon2Finder, findsOneWidget);
    });
  });

  testWidgets('LogOutDialog cancel test', (tester) async {
    await tester.runAsync(() async {
      var confirmed = false;
      var canceled = false;
      final dialog = CustomDialog(constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),title: 'Sign out', bodyText: 'Are you sure you want to sign out?', confirm: (){confirmed = true;}, cancel: (){canceled = true;});

      final icon2Finder = find.byIcon(Icons.cancel);

      await tester.pumpWidget(MaterialApp(
          title: 'Flutter Demo', home: Scaffold(body: dialog),),);

      await tester.pump(const Duration());

      await tester.tap(icon2Finder);

      await tester.pump(const Duration());
      await tester.pumpAndSettle();

      expect(confirmed, false);
      expect(canceled, true);
    });
  });

  testWidgets('LogOutDialog accept test', (tester) async {
    await tester.runAsync(() async {
      // tests
      var confirmed = false;
      var canceled = false;
      final dialog = CustomDialog(constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),title: 'Sign out', bodyText: 'Are you sure you want to sign out?', confirm: (){confirmed = true;}, cancel: (){canceled = true;});

      final iconFinder = find.byIcon(Icons.check_circle);

      await tester.pumpWidget(MaterialApp(
          title: 'Flutter Demo', home: Scaffold(body: dialog),),);

      await tester.pump(const Duration());

      await tester.tap(iconFinder);

      await tester.pump(const Duration());
      await tester.pumpAndSettle();

      expect(canceled, false);
      expect(confirmed, true);
    });
  });
}
