import 'package:flutter/material.dart';
import 'package:launchpad/styles/app_styles.dart';

class BasicTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final VoidCallback? textChanged;
  final int maxLength;
  final String? helperText;
  final String? errorText;
  final Widget? prefixIcon;
  final BoxConstraints prefixIconConstraints;
  final Widget? suffixIcon;
  final BoxConstraints suffixIconConstraints;
  final int? minLines;
  final int? maxLines;
  final bool autocorrect;
  final TextCapitalization textCapitalization;
  final VoidCallback? onEditingComplete;
  final void Function(String s)? onSubmitted;
  final TextInputType? keyboardType;
  final bool? obscure;

  const BasicTextField({
    super.key,
    required this.controller,
    this.maxLength = 1200,
    this.obscure = false,
    this.autofocus = false,
    this.focusNode,
    this.hintText = '',
    this.textChanged,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.prefixIconConstraints = const BoxConstraints(
      maxHeight: 16.0,
      maxWidth: 48.0,
    ),
    this.suffixIcon,
    this.suffixIconConstraints = const BoxConstraints(
      maxHeight: 16.0,
      maxWidth: 48.0,
    ),
    this.autocorrect = true,
    this.minLines,
    this.maxLines,
    this.textCapitalization = TextCapitalization.words,
    this.onEditingComplete,
    this.onSubmitted,
    this.keyboardType,
  });

  const BasicTextField.singleLine({
    super.key,
    required this.controller,
    this.obscure,
    this.autofocus = false,
    this.maxLength = 1200,
    this.focusNode,
    this.hintText = '',
    this.textChanged,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.prefixIconConstraints = const BoxConstraints(
      maxHeight: 16.0,
      maxWidth: 48.0,
    ),
    this.suffixIcon,
    this.suffixIconConstraints = const BoxConstraints(
      maxHeight: 16.0,
      maxWidth: 48.0,
    ),
    this.autocorrect = true,
    this.minLines = 1,
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.words,
    this.onEditingComplete,
    this.onSubmitted,
    this.keyboardType,
  });

  const BasicTextField.multiLine({
    super.key,
    required this.controller,
    this.obscure,
    this.maxLength = 1200,
    this.focusNode,
    this.hintText = '',
    this.autofocus = false,
    this.textChanged,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.prefixIconConstraints = const BoxConstraints(
      maxHeight: 16.0,
      maxWidth: 48.0,
    ),
    this.suffixIcon,
    this.suffixIconConstraints = const BoxConstraints(
      maxHeight: 16.0,
      maxWidth: 48.0,
    ),
    this.autocorrect = true,
    this.minLines = 10,
    this.maxLines = 15,
    this.textCapitalization = TextCapitalization.sentences,
    this.onEditingComplete,
    this.onSubmitted,
    this.keyboardType,
  });

  OutlineInputBorder _determineBorderStyle(
    bool isValid,
    BuildContext context,
  ) =>
      OutlineInputBorder(
        borderSide: BorderSide(
          color: isValid ? Colors.transparent : Colors.redAccent,
          width: 2.0,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      );

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            cursorColor: const Color(0xFFFEFFF4),
            obscureText: obscure ?? false,
            keyboardType: keyboardType,
            onEditingComplete: onEditingComplete,
            onFieldSubmitted: onSubmitted,
            validator: (s) {
              if (s == null || s.isEmpty) {
                return 'Invalid input';
              }
              return null;
            },
            maxLength: maxLength,
            autofocus: autofocus,
            focusNode: focusNode,
            textCapitalization: textCapitalization,
            style: AppStyles.poppinsBold22.copyWith(fontSize: 16),
            controller: controller,
            textAlign: TextAlign.start,
            onChanged: (String s) => textChanged?.call(),
            decoration: InputDecoration(
              counter: const SizedBox(),
              filled: true,
              border: InputBorder.none,
              fillColor: AppStyles.panelColor,
              hintText: hintText,
              hintStyle: AppStyles.poppinsBold22
                  .copyWith(color: Colors.white70, fontSize: 18),
              // prefixIcon: prefixIcon,
              // prefixIconConstraints: prefixIconConstraints,
              // suffixIcon: suffixIcon,
              // suffixIconConstraints: suffixIconConstraints,
              isDense: false,
              // contentPadding: const EdgeInsets.symmetric(
              //   vertical: 14.0,
              //   horizontal: 16.0,
              // ),
              // enabledBorder:
              //     _determineBorderStyle(controller.text.isNotEmpty, context),
              // focusedBorder: _determineBorderStyle(inputIsValid, context),
              // errorBorder:
              //     _determineBorderStyle(controller.text.isNotEmpty, context),
              // focusedErrorBorder: _determineBorderStyle(inputIsValid, context),
            ),
          ),
        ],
      );
}
