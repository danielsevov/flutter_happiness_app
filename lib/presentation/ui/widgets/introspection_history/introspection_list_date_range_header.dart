import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:happiness_app/helper.dart';
import 'package:intl/intl.dart';

enum RangeSelection { thisWeek, lastWeek, thisMonth, lastMonth, anytime }

class DateRangePickerHeader extends StatefulWidget {
  const DateRangePickerHeader({
    required this.onDateRangeSelected,
    required this.constraints,
    super.key,
  });
  final ValueChanged<DateTimeRange?> onDateRangeSelected;
  final BoxConstraints constraints;

  @override
  DateRangePickerHeaderState createState() => DateRangePickerHeaderState();
}

/// Header for the report list view, which allows the user to change the
/// data range which is being shown in the list
class DateRangePickerHeaderState extends State<DateRangePickerHeader> {
  DateTimeRange? _dateRange;
  RangeSelection? _selectedOption = RangeSelection.anytime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setDateRange(RangeSelection.anytime);
    });
  }

  DateTimeRange _getWeekRange(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return DateTimeRange(start: startOfWeek, end: endOfWeek);
  }

  DateTimeRange _getMonthRange(DateTime date) {
    final startOfMonth = DateTime(date.year, date.month);
    final endOfMonth = DateTime(date.year, date.month + 1, 0);
    return DateTimeRange(start: startOfMonth, end: endOfMonth);
  }

  String rangeSelectionToString(RangeSelection value) {
    switch (value) {
      case RangeSelection.thisWeek:
        return AppLocalizations.of(context)!.thisWeek;
      case RangeSelection.lastWeek:
        return AppLocalizations.of(context)!.lastWeek;
      case RangeSelection.thisMonth:
        return AppLocalizations.of(context)!.thisMonth;
      case RangeSelection.lastMonth:
        return AppLocalizations.of(context)!.lastMonth;
      case RangeSelection.anytime:
        return AppLocalizations.of(context)!.anytime;
    }
  }

  void _setDateRange(RangeSelection? option) {
    if (option == null) return;
    final now = DateTime.now();
    DateTimeRange? newRange;

    switch (option) {
      case RangeSelection.thisWeek:
        newRange = _getWeekRange(now);
        break;
      case RangeSelection.lastWeek:
        newRange = _getWeekRange(now.subtract(const Duration(days: 7)));
        break;
      case RangeSelection.thisMonth:
        newRange = _getMonthRange(now);
        break;
      case RangeSelection.lastMonth:
        newRange = _getMonthRange(DateTime(now.year, now.month - 1));
        break;
      case RangeSelection.anytime:
        newRange = null;
        break;
    }

    setState(() {
      _dateRange = newRange;
      _selectedOption = option;
    });

    widget.onDateRangeSelected(_dateRange);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (_dateRange != null)
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  '${DateFormat.yMMMd().format(_dateRange!.start)}'
                  ' - ${DateFormat.yMMMd().format(_dateRange!.end)}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: Helper.getSmallTextSize(widget.constraints),
                      ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _dateRange = null;
                    _selectedOption = RangeSelection.anytime;
                  });
                  widget.onDateRangeSelected(null);
                },
                icon: Icon(
                  Icons.clear,
                  size: Helper.getIconSize(widget.constraints),
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ],
          )
        else
          const SizedBox(),
        Row(
          children: [
            DropdownButton<RangeSelection>(
              value: _selectedOption,
              focusColor: Colors.transparent,
              icon: Icon(
                Icons.arrow_drop_down,
                size: Helper.getIconSize(widget.constraints),
                color: Theme.of(context).colorScheme.onBackground,
              ),
              onChanged: _setDateRange,
              items: RangeSelection.values
                  .map<DropdownMenuItem<RangeSelection>>(
                      (RangeSelection value) {
                return DropdownMenuItem<RangeSelection>(
                  value: value,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      rangeSelectionToString(value),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize:
                                Helper.getSmallTextSize(widget.constraints),
                          ),
                    ),
                  ),
                );
              }).toList(),
            ),
            IconButton(
              onPressed: () async {
                final pickedDateRange = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  builder: (BuildContext context, Widget? child) {
                    return SingleChildScrollView(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: SizedBox(
                            width: widget.constraints.maxWidth > 400
                                ? 400
                                : widget.constraints.maxWidth,
                            height: widget.constraints.maxHeight > 600
                                ? 600
                                : widget.constraints.maxHeight,
                            child: child,
                          ),
                        ),
                      ),
                    );
                  },
                );
                if (pickedDateRange != null) {
                  setState(() {
                    _dateRange = pickedDateRange;
                    _selectedOption = null;
                  });
                  widget.onDateRangeSelected(_dateRange);
                }
              },
              icon: Icon(
                Icons.date_range,
                size: Helper.getIconSize(widget.constraints),
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
