// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first

import 'package:flutter/material.dart';
import 'package:happiness_app/domain/models/happiness_report_model.dart';
import 'package:happiness_app/presentation/ui/widgets/daily_introspection/daily_intro_report_body_narrow.dart';
import 'package:happiness_app/presentation/ui/widgets/daily_introspection/daily_intro_report_body_wide.dart';
import 'package:happiness_app/presentation/ui/widgets/daily_introspection/daily_intro_report_header.dart';
import 'package:happiness_app/presentation/ui/widgets/weekly_retrospection/weekly_retro_report_body_narrow.dart';
import 'package:happiness_app/presentation/ui/widgets/weekly_retrospection/weekly_retro_report_header.dart';

/// This widgets is used for visualizing happiness report entries.
/// The questions asked and the answers of the user are displayed.
class HappinessReport extends StatefulWidget {
  const HappinessReport({
    super.key,
    required this.report,
    required this.rank,
  });
  final HappinessReportModel report;
  final int rank;

  @override
  State<HappinessReport> createState() => _HappinessReportState();
}

class _HappinessReportState extends State<HappinessReport>
    with TickerProviderStateMixin {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ColoredBox(
          color: Theme.of(context).colorScheme.background,
          child: Container(
            width: widget.report.isDailyReport
                ? constraints.maxWidth < 800
                    ? constraints.maxWidth
                    : 800
                : constraints.maxWidth < 600
                    ? constraints.maxWidth
                    : 600,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              border: Border.all(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Wrap(
              children: [
                // header of the report
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isOpen = !_isOpen;
                    });
                  },
                  child: widget.report.isDailyReport
                      ? DailyIntroReportHeader(
                          report: widget.report,
                          rank: widget.rank,
                          isOpen: _isOpen,
                        )
                      : WeeklyRetroReportHeader(
                          report: widget.report,
                          rank: widget.rank,
                          isOpen: _isOpen,
                        ),
                ),

                // body of the report
                AnimatedSize(
                  duration: Duration(milliseconds: 200),
                  child: AnimatedOpacity(
                    opacity: _isOpen ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 200),
                    child: _isOpen
                        ? widget.report.isDailyReport
                            ? constraints.maxWidth < 800
                                ? DailyIntrospectionReportBodyNarrow(
                                    report: widget.report,
                                    constraints: constraints,
                                  )
                                : DailyIntrospectionReportBodyWide(
                                    report: widget.report,
                                    constraints: constraints,
                                  )
                            : WeeklyRetrospectionReportBodyNarrow(
                                report: widget.report,
                                constraints: constraints,
                              )
                        : Container(),
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
