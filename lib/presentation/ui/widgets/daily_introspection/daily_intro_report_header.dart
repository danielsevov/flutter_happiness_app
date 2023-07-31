// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:happiness_app/domain/models/happiness_report_model.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/ui/pages/daily_intro_page.dart';

import 'package:happiness_app/presentation/state_management/providers.dart';
import 'package:intl/intl.dart';


class DailyIntroReportHeader extends ConsumerWidget {
  const DailyIntroReportHeader(
      {super.key, required this.report, required this.rank, required this.isOpen,});
  final HappinessReportModel report;
  final int rank;
  final bool isOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                        '${report.date}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontSize: Helper.getSmallHeadingSize(constraints),
                            ),
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          IconButton(onPressed: (){
                            Helper.replacePageWithSlideAnimation(
                              context,
                              DailyIntrospectionPage(
                                presenter: ref.watch(dailyIntroPresenterProvider), date: DateFormat('yyyy-MM-dd').format(Helper.formatter.parse(report.date)),),
                            );
                          }, color: Colors.white, icon: Icon(Icons.edit_note, size: Helper.getIconSize(constraints), color: Theme.of(context).colorScheme.primary,)),
                          SizedBox(
                            height: Helper.getIconSize(constraints),
                            width: Helper.getIconSize(constraints),
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
