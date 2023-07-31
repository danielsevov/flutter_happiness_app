// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first

import 'package:flutter/material.dart';
import 'package:happiness_app/domain/models/happiness_report_model.dart';

/// Abstract base for all happiness report visualisation widgets
abstract class BaseReportBody extends StatelessWidget {
  const BaseReportBody(
      {super.key, required this.report, required this.constraints,});
  final HappinessReportModel report;
  final BoxConstraints constraints;
}
