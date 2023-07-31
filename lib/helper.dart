// ignore_for_file: lines_longer_than_80_chars, prefer_final_locals, strict_raw_type, inference_failure_on_instance_creation

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:happiness_app/domain/models/empty_model.dart';
import 'package:happiness_app/domain/models/happiness_report_model.dart';
import 'package:happiness_app/domain/models/happiness_settings_model.dart';
import 'package:happiness_app/domain/models/model.dart';
import 'package:happiness_app/domain/models/test_model.dart';
import 'package:happiness_app/domain/models/user_model.dart';
import 'package:intl/intl.dart';

class Helper {
  // model names
  static const String testModel = 'x_test_model';
  static const String userModel = 'hr.employee';
  static const String happinessSettingsModel = 'x_happiness_settings';
  static const String happinessReportModel = 'x_happiness_report';

  /// Converts a JSON object to a model object of the given type.
  ///
  /// - [modelName]: The type of model to convert to.
  /// - [json]: The JSON object to convert.
  ///
  /// Returns a [Model] object or [EmptyModel] model if the model name is invalid.
  static Model getModelFromJson(String modelName, dynamic json) {
    switch (modelName) {
      // TODO(danielsevov): Add cases for each model type
      case testModel:
        return TestModel.fromJson(json as Map<String, dynamic>);
      case userModel:
        return UserModel.fromJson(json as Map<String, dynamic>);
      case happinessSettingsModel:
        return HappinessSettingsModel.fromJson(json as Map<String, dynamic>);
      case happinessReportModel:
        return HappinessReportModel.fromJson(json as Map<String, dynamic>);
      default:
        return EmptyModel();
    }
  }

  static final DateFormat formatter = DateFormat('dd-MM-yyyy');

  static double getButtonTextSize(BoxConstraints constraints) {
    return constraints.maxWidth < 400 ? constraints.maxWidth / 35 : 14;
  }

  static double getBigHeadingSize(BoxConstraints constraints) {
    return constraints.maxWidth < 400 ? constraints.maxWidth / 20 : 20;
  }

  static double getSmallHeadingSize(BoxConstraints constraints) {
    return constraints.maxWidth < 400 ? constraints.maxWidth / 24 : 18;
  }

  static double getNormalTextSize(BoxConstraints constraints) {
    return constraints.maxWidth < 400 ? constraints.maxWidth / 30 : 14;
  }

  static double getSmallTextSize(BoxConstraints constraints) {
    return constraints.maxWidth < 400 ? constraints.maxWidth / 40 : 12;
  }

  static double getIconSize(BoxConstraints constraints) {
    return constraints.maxWidth < 400 ? constraints.maxWidth / 20 : 22;
  }

  static double getDrawerSize(BoxConstraints constraints) {
    return constraints.maxWidth / 1.2 > 350 ? 350 : constraints.maxWidth / 1.2;
  }

  /// Function for making SnackBar toasts
  static void makeToast(BuildContext context, String string) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(string),
      ),
    );
  }

  /// Function to push page with slide animation to navigator.
  static void pushPageWithSlideAnimation(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) =>
            !Platform.isMacOS
                ? page
                : Scaffold(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    body: Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: page,
                    )),
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
      ),
    );
  }

  /// Function to replace by the Navigator the current page with a new one with a slide animation.
  static void replacePageWithSlideAnimation(BuildContext context, Widget page) {
    Route route = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => !Platform.isMacOS
          ? page
          : Scaffold(
              backgroundColor: Theme.of(context).colorScheme.primary,
              body: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: page,
              )),
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
    Navigator.pushReplacement(context, route);
  }

  /// Function to replace by the Navigator the current page with a new one with a back slide animation.
  static void replacePageWithBackSlideAnimation(BuildContext context, Widget page) {
    Route route = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => !Platform.isMacOS
          ? page
          : Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primary,
          body: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: page,
          )),
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
    Navigator.pushReplacement(context, route);
  }

  /// Adds the specified number of weeks to the given date.
  static DateTime addWeeksToDate(DateTime date, int weeks) {
    return date.add(Duration(days: 7 * weeks));
  }

  /// Calculates the number of weeks between the two specified dates.
  static int getWeeksDifference(DateTime startDate, DateTime endDate) {
    final startOfWeek = _startOfWeek(startDate);
    final endOfWeek = _startOfWeek(endDate);

    final diff = endOfWeek.difference(startOfWeek).inDays;
    return (diff / 7).floor();
  }

  /// Returns the start of the week for the given date.
  static DateTime _startOfWeek(DateTime date) {
    final daysFromStartOfWeek = date.weekday - DateTime.monday;
    return date.subtract(Duration(days: daysFromStartOfWeek));
  }

  /// Returns the Monday of the week for the given date.
  static DateTime getMondayOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  /// Returns the Monday of the week for the given week number and year.
  static DateTime getMondayOfTheWeekByNumber(int weekNumber, int year) {
    // Define the start of the year
    DateTime startDate = DateTime(year, 1, 4); // 4th Jan is guaranteed to be in week 1 according to ISO 8601

    // If the start date isn't a Monday, move to the previous Monday
    while (startDate.weekday != DateTime.monday) {
      startDate = startDate.subtract(Duration(days: 1));
    }

    // Add (weekNumber - 1) * 7 days to the start date to find the Monday of the target week
    DateTime weekStartDate = startDate.add(Duration(days: (weekNumber - 1) * 7));

    return weekStartDate;
  }


  /// Get the week number of the given date
  static int getWeekNumber(DateTime date) {
    final dayOfYear = int.parse(DateFormat('D').format(date));
    final woy = ((dayOfYear - date.weekday + 10) / 7).floor();
    return woy;
  }


  /// Used to convert string to Day
  static Day convertStringToDay(String dayString) {
    switch (dayString) {
      case 'Sunday':
        return Day.sunday;
      case 'Monday':
        return Day.monday;
      case 'Tuesday':
        return Day.tuesday;
      case 'Wednesday':
        return Day.wednesday;
      case 'Thursday':
        return Day.thursday;
      case 'Friday':
        return Day.friday;
      case 'Saturday':
        return Day.saturday;
      default:
        return Day.friday;
    }
  }

  /// Used to convert Day to string
  static String convertDayToString(Day day) {
    switch (day) {
      case Day.sunday:
        return 'Sunday';
      case Day.monday:
        return 'Monday';
      case Day.tuesday:
        return 'Tuesday';
      case Day.wednesday:
        return 'Wednesday';
      case Day.thursday:
        return 'Thursday';
      case Day.friday:
        return 'Friday';
      case Day.saturday:
        return 'Saturday';
      default:
        throw Exception('Invalid day: $day');
    }
  }
}
