// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, avoid_multiple_declarations_per_line, inference_failure_on_function_return_type

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/ui/widgets/reusable/dialogs/icon_button_guide_dialog.dart';

/// Custom answer TextFormField, which can be reused for multiple questions.
class AnswerTextField extends StatefulWidget {
  // Simple constructor for the log in form instance, which takes the context screen dimensions and the business logic object.
  const AnswerTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.onChanged,
    this.validator,
    required this.constraints,
    required this.question,
    required this.guide,
    required this.isNewReport,
  });
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String hint, question, guide;
  final IconData icon;
  final Function(String)? onChanged;
  final BoxConstraints constraints;
  final bool isNewReport;

  @override
  State<AnswerTextField> createState() => _AnswerTextFieldState();
}

class _AnswerTextFieldState extends State<AnswerTextField> {
  bool isEnabled = true;
  bool firstRun = true;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if(widget.controller.text.isEmpty && !widget.isNewReport && firstRun) {
      setState(() {
        isEnabled = false;
        firstRun = false;
      });
    }

    return SizedBox(
      width: widget.constraints.maxWidth < 800 ? widget.constraints.maxWidth : 800,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    widget.question,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.w700,
                      fontSize: Helper.getNormalTextSize(widget.constraints),
                    ),
                  ),
                ),
              ),
              IconButtonGuideDialog(
                title: widget.question,
                guideline: widget.guide,
                constraints: widget.constraints,
                close: localizations.close,
              ),
            ],
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            child: AnimatedOpacity(
              opacity: isEnabled ? 1.0 : 0.1, // Reduced opacity when disabled
              duration: Duration(milliseconds: 500), // Increased duration
              child: isEnabled ? Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: widget.controller,
                  textCapitalization: TextCapitalization.sentences,
                  inputFormatters: [EachWordTextInputFormatter()],
                  textAlign: TextAlign.center,
                  maxLines: 10,
                  minLines: 1,
                  maxLength: 500,
                  onChanged: widget.onChanged,
                  validator: widget.validator,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      widget.icon,
                      size: Helper.getIconSize(widget.constraints),
                    ),
                    filled: Theme.of(context).inputDecorationTheme.filled,
                    fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                    errorStyle: Theme.of(context).inputDecorationTheme.errorStyle,
                    focusedBorder:
                    Theme.of(context).inputDecorationTheme.focusedBorder,
                    focusedErrorBorder:
                    Theme.of(context).inputDecorationTheme.focusedErrorBorder,
                    errorBorder:
                    Theme.of(context).inputDecorationTheme.errorBorder,
                    enabledBorder:
                    Theme.of(context).inputDecorationTheme.enabledBorder,
                    hintText: widget.hint,
                    hintStyle: Theme.of(context)
                        .inputDecorationTheme
                        .hintStyle
                        ?.copyWith(
                      fontSize: Helper.getNormalTextSize(widget.constraints),
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: Helper.getNormalTextSize(widget.constraints),
                  ),
                ),
              ) : const SizedBox(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    isEnabled = !isEnabled;
                    if (!isEnabled) {
                      widget.controller.text = '';
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    isEnabled
                        ? localizations.skipQuestion
                        : localizations.openQuestion,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: Helper.getSmallTextSize(widget.constraints),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EachWordTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue,) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    return TextEditingValue(
      text: newValue.text
          .split('. ')
          .map((sentence) => sentence.isEmpty
              ? sentence
              : sentence[0].toUpperCase() + sentence.substring(1),)
          .join('. '),
      selection: newValue.selection,
    );
  }
}
