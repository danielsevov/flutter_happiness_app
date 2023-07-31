import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happiness_app/domain/models/user_model.dart';
import 'package:happiness_app/presentation/ui/widgets/daily_introspection/happiness_report.dart';
import 'package:happiness_app/presentation/ui/widgets/manager_dashboard/grouped_reports.dart';

import '../../localizations_injection.dart';

void main() {
  final user = UserModel.fromJson({'id': 1, 'name': 'John Doe'});
  final reports = <HappinessReport>[];

  testWidgets('should display user name', (WidgetTester tester) async {
    await tester.pumpWidget(LocalizationsInj(
      locale: const Locale('en'),
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: GroupedReports(
              user: user,
              reports: reports,
              constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),
              noEntryString: 'No netry found!',
            ),
          ),
        ),
      ),
    ));

    await tester.pumpAndSettle();

    expect(find.text('John Doe'), findsOneWidget);
  });

  testWidgets('test expand and collapse', (WidgetTester tester) async {
    await tester.pumpWidget(ProviderScope(
      child: LocalizationsInj(
        locale: const Locale('en'),
        child: MaterialApp(
          supportedLocales: const [Locale('en')],
          home: Scaffold(
            body: Center(
              child: GroupedReports(
                user: user,
                reports: reports,
                constraints:
                    const BoxConstraints(maxWidth: 400, maxHeight: 400),
                noEntryString: 'No entry found!',
              ),
            ),
          ),
        ),
      ),
    ));

    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.expand_more), findsOneWidget);
    expect(find.byIcon(Icons.expand_less), findsNothing);

    // Tap the expand button.
    await tester.tap(find.byIcon(Icons.expand_more));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.expand_less), findsOneWidget);
    expect(find.byIcon(Icons.expand_more), findsNothing);

    // Tap the collapse button.
    await tester.tap(find.byIcon(Icons.expand_less));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.expand_more), findsOneWidget);
    expect(find.byIcon(Icons.expand_less), findsNothing);
  });
}
