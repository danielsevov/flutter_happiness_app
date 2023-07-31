import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:happiness_app/app_colors.dart';
import 'package:happiness_app/helper.dart';

import 'introspection_chart.dart';

class IntrospectionTimeChart extends StatelessWidget {
  const IntrospectionTimeChart({
    required this.averages,
    required this.constraints,
    required this.smallLabel,
    required this.groupBy,
    required this.numberOfPeriods,
    Key? key,
  }) : super(key: key);

  final List<AverageHappinessReport> averages;
  final BoxConstraints constraints;
  final bool smallLabel;
  final GroupBy groupBy;
  final int numberOfPeriods;

  @override
  Widget build(BuildContext context) {
    List<FlSpot> happinessSpots = [];
    List<FlSpot> sadnessSpots = [];
    List<FlSpot> fearSpots = [];
    List<FlSpot> angerSpots = [];
    double xVal = 0;
    var textStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
      color: Theme.of(context).colorScheme.onBackground,
      fontSize: smallLabel ? Helper.getSmallTextSize(constraints) / 2.5 : Helper.getSmallTextSize(constraints) / 1.5,
    );

    for (final report in averages) {
      if (report.hasReports) {
        averages.first.visibleFeelings['happiness'] == true ? happinessSpots.add(FlSpot(xVal, report.happinessLevel)) : null;
        averages.first.visibleFeelings['sadness'] == true ? sadnessSpots.add(FlSpot(xVal, report.sadnessLevel)) : null;
        averages.first.visibleFeelings['fear'] == true ? fearSpots.add(FlSpot(xVal, report.fearLevel)) : null;
        averages.first.visibleFeelings['anger'] == true ? angerSpots.add(FlSpot(xVal, report.angerLevel)) : null;
      }
      xVal += 1;
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true, drawVerticalLine: false, drawHorizontalLine: true),
        lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Theme.of(context).colorScheme.background,
            )
        ),
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  switch(groupBy) {
                    case GroupBy.month:
                    // Logic to handle monthly data
                      return Text("y${averages[value.toInt().clamp(0, numberOfPeriods)].year.substring(2)}", style: textStyle);
                    case GroupBy.week:
                    // Logic to handle weekly data
                      return Text("y${averages[value.toInt().clamp(0, numberOfPeriods)].year.substring(2)}", style: textStyle);
                    case GroupBy.day:
                    // Logic to handle daily data
                      return Text("m${averages[value.toInt().clamp(0, numberOfPeriods)].month}", style: textStyle);
                    default:
                      return Text("");
                  }
                },
                interval: 1,
              )
          ),
          rightTitles: AxisTitles(),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  switch(groupBy) {
                    case GroupBy.month:
                    // Logic to handle monthly data
                      return Text("\nm${averages[value.toInt().clamp(0, numberOfPeriods)].month}",  style: textStyle);
                    case GroupBy.week:
                    // Logic to handle weekly data
                      return Text("\nw${averages[value.toInt().clamp(0, numberOfPeriods)].periodNumber}", style: textStyle);
                    case GroupBy.day:
                    // Logic to handle daily data
                      return Text("\nd${averages[value.toInt().clamp(0, numberOfPeriods)].periodNumber}", style: textStyle);
                    default:
                      return Text("");
                  }
                },
                interval: 1,
              )
          ),
        ),
        minX: 0,
        maxX: xVal-1,
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(spots: happinessSpots, color: AppColors.happinessColor),
          LineChartBarData(spots: sadnessSpots, color: AppColors.sadnessColor),
          LineChartBarData(spots: fearSpots, color: AppColors.fearColor),
          LineChartBarData(spots: angerSpots, color: AppColors.angerColor),
        ],
      ),
    );
  }
}