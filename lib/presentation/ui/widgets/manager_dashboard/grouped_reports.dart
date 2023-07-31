import 'package:flutter/material.dart';
import 'package:happiness_app/domain/models/user_model.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/ui/widgets/daily_introspection/happiness_report.dart';

/// This widget holds a list of happiness reports for a single user.
class GroupedReports extends StatefulWidget {

  const GroupedReports({ required this.user, required this.reports,
    required this.constraints, required this.noEntryString, super.key,});
  final UserModel user;
  final List<HappinessReport> reports;
  final BoxConstraints constraints;
  final String noEntryString;

  @override
  GroupedReportsState createState() => GroupedReportsState();
}

class GroupedReportsState extends State<GroupedReports> with TickerProviderStateMixin {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final userReports = widget.reports
        .where((report) => report.report.employeeId == widget.user.id)
        .toList();

    return Container(
      width: widget.constraints.maxWidth > 800
          ? 800
          : widget.constraints.maxWidth,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .onBackground
              .withOpacity(0.5),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  size: Helper.getIconSize(widget.constraints),
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
              ),

              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  widget.user.name ?? 'Unknown',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: Helper.getNormalTextSize(widget.constraints),
                  ),
                ),
              ),
            ],
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 200),
            child: AnimatedOpacity(
              opacity: isExpanded ? 1.0 : 0.0,
              duration: Duration(milliseconds: 200),
              child: isExpanded
                  ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: userReports.isNotEmpty ? userReports.length : 1,
                itemBuilder: (BuildContext context, int index) {
                  if (userReports.isNotEmpty) {
                    return userReports[index];
                  } else {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          widget.noEntryString,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize:
                            Helper.getNormalTextSize(widget.constraints),
                          ),
                        ),
                      ),
                    );
                  }
                },
              )
                  : Container(),
            ),
          ),
        ],
      ),
    );
  }
}
