// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:happiness_app/domain/models/happiness_report_model.dart';
import 'package:happiness_app/helper.dart';

import 'package:happiness_app/presentation/state_management/providers.dart';
import 'package:happiness_app/presentation/ui/pages/weekly_retro_page.dart';

class WeeklyRetroReportHeader extends ConsumerWidget {
  const WeeklyRetroReportHeader(
      {super.key, required this.report, required this.rank, required this.isOpen,});
  final HappinessReportModel report;
  final int rank;
  final bool isOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = Helper.formatter.parse(report.date);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: Helper.getIconSize(constraints) * 2,
                        child: Text(
                          '#$rank',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: Helper.getSmallHeadingSize(constraints),
                          ),
                        ),
                      ),
                      Text(
                        '${AppLocalizations.of(context)!.week} ${Helper.getWeekNumber(date)}, ${date.year}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontSize: Helper.getSmallHeadingSize(constraints),
                            ),
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          IconButton(onPressed: (){
                            var date = Helper.formatter.parse(report.date);
                            Helper.replacePageWithSlideAnimation(
                              context,
                              WeeklyRetrospectionPage(
                                presenter: ref.watch(weeklyRetroPresenterProvider), weekNumber: Helper.getWeekNumber(date), year: date.year,
                            ));
                          }, color: Colors.white, icon: Icon(Icons.edit_note, size: Helper.getIconSize(constraints), color: Theme.of(context).colorScheme.primary,)),
                          SizedBox(
                            height: Helper.getIconSize(constraints),
                            child: Icon(
                              !isOpen
                                  ? Icons.keyboard_arrow_down
                                  : Icons.keyboard_arrow_up,
                              color: Theme.of(context).colorScheme.primary,
                              size: Helper.getIconSize(constraints),
                            ),
                          ),
                        ],
                      )

                    ],
                  );
      },
    );
  }
}
