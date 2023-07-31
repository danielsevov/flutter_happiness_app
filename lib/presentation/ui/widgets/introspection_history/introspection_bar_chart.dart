import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:happiness_app/app_colors.dart';
import 'package:happiness_app/helper.dart';

import 'introspection_chart.dart';

class IntrospectionBarChart extends StatelessWidget {
  const IntrospectionBarChart({
    required this.averages,
    required this.constraints,
    required this.smallLabel,
    required this.groupBy,
    Key? key,
  }) : super(key: key);

  final List<AverageHappinessReport> averages;
  final BoxConstraints constraints;
  final bool smallLabel;
  final GroupBy groupBy;

  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barChartData = [];
    var textStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
      color: Theme.of(context).colorScheme.onBackground,
      fontSize: smallLabel ? Helper.getSmallTextSize(constraints) / 2.5 : Helper.getSmallTextSize(constraints) / 1.5,
    );

    for (int index = 0; index < averages.length; index++) {
      List<BarChartRodData> barRods = [];
      if (averages.first.visibleFeelings['happiness'] == true) {
        barRods.add(BarChartRodData(
          toY: averages[index].happinessLevel,
          color: AppColors.happinessColor,
          width: constraints.maxWidth / (averages.length * 15),
        ));
      }
      if (averages.first.visibleFeelings['sadness'] == true) {
        barRods.add(BarChartRodData(
          toY: averages[index].sadnessLevel,
          color: AppColors.sadnessColor,
          width: constraints.maxWidth / (averages.length * 15),
        ));
      }
      if (averages.first.visibleFeelings['anger'] == true) {
        barRods.add(BarChartRodData(
          toY: averages[index].angerLevel,
          color: AppColors.angerColor,
          width: constraints.maxWidth / (averages.length * 15),
        ));
      }
      if (averages.first.visibleFeelings['fear'] == true) {
        barRods.add(BarChartRodData(
          toY: averages[index].fearLevel,
          color: AppColors.fearColor,
          width: constraints.maxWidth / (averages.length * 15),
        ));
      }
      barChartData.add(BarChartGroupData(x: index, barRods: barRods));
    }

    return BarChart(
      BarChartData(
        barGroups: barChartData,
        gridData: FlGridData(show: true, drawVerticalLine: false, drawHorizontalLine: true),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Theme.of(context).colorScheme.background,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              switch(rodIndex) {
                case 0:
                  return BarTooltipItem("Happiness: ${rod.toY.toStringAsFixed(2)}", textStyle!);
                case 1:
                  return BarTooltipItem("Sadness: ${rod.toY.toStringAsFixed(2)}", textStyle!);
                case 2:
                  return BarTooltipItem("Anger: ${rod.toY.toStringAsFixed(2)}", textStyle!);
                case 3:
                  return BarTooltipItem("Fear: ${rod.toY.toStringAsFixed(2)}", textStyle!);
                default:
                  return BarTooltipItem("", textStyle!);
              }
            },
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
                    return Text("y${averages[value.toInt()].year.substring(2)}", style: textStyle);
                  case GroupBy.week:
                  // Logic to handle weekly data
                    return Text("y${averages[value.toInt()].year.substring(2)}", style: textStyle);
                  case GroupBy.day:
                  // Logic to handle daily data
                    return Text("m${averages[value.toInt()].month}", style: textStyle);
                  default:
                    return Text("");
                }
              },
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
                    return Text("m${averages[value.toInt()].month}",  style: textStyle);
                  case GroupBy.week:
                  // Logic to handle weekly data
                    return Text("w${averages[value.toInt()].periodNumber}", style: textStyle);
                  case GroupBy.day:
                  // Logic to handle daily data
                    return Text("d${averages[value.toInt()].periodNumber}", style: textStyle);
                  default:
                    return Text("");
                }
              },
            )
          ),
        ),
        borderData: FlBorderData(show: false,),
      ),
    );
  }
}


