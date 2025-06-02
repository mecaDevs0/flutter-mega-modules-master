import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:megaleios_flutter_localization/megaleios_flutter_localization.dart';
import 'package:validatorless/validatorless.dart';

import 'formats.dart';
import 'my_date_utils.dart';

class TextFieldUtils {
  static Widget buildField(
    BuildContext context, {
    String? label,
    String? hint,
    List<TextInputFormatter>? inputFormats,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.done,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextEditingController? controller,
    InputDecoration? decoration,
    FocusNode? focusNode,
    TextAlign textAlign = TextAlign.start,
    bool required = false,
    bool hasPadding = true,
    bool enabled = true,
    bool filled = false,
    int? minLines,
    int? maxLines,
    int? minLength,
    TextStyle? style,
    Function()? onTap,
    Function(String)? onChanged,
    Function(String?)? onSaved,
    Function(String)? onFieldSubmitted,
    Function(String?)? validator,
    bool isReadOnly = false,
  }) {
    bool obscureText = keyboardType == TextInputType.visiblePassword;
    final isPassword = keyboardType == TextInputType.visiblePassword;

    return StatefulBuilder(
      builder: (_, setState) {
        return Padding(
          padding: EdgeInsets.only(bottom: hasPadding ? 20 : 0),
          child: TextFormField(
            keyboardType: keyboardType,
            readOnly: isReadOnly,
            textInputAction: textInputAction,
            textCapitalization: textCapitalization,
            decoration: decoration != null
                ? decoration
                : InputDecoration(
                    labelText: label ?? '',
                    hintText: hint ?? '',
                    filled: filled,
                    suffixIcon: isPassword
                        ? IconButton(
                            icon: Icon(
                              obscureText
                                  ? FontAwesomeIcons.solidEye
                                  : FontAwesomeIcons.solidEyeSlash,
                              color: Colors.grey,
                              size: 16,
                            ),
                            onPressed: () => {
                              setState(() {
                                obscureText = !obscureText;
                              })
                            },
                          )
                        : null,
                  ),
            maxLines: obscureText ? 1 : maxLines,
            minLines: obscureText ? 1 : minLines,
            focusNode: focusNode,
            inputFormatters: inputFormats,
            controller: controller,
            obscureText: obscureText,
            onChanged: onChanged,
            onTap: onTap,
            onSaved: onSaved,
            onFieldSubmitted: onFieldSubmitted,
            style: style,
            textAlign: textAlign,
            enabled: enabled,
            validator: (value) {
              if (required && (value == null || value.trim().isEmpty)) {
                return MegaleiosLocalizations.of(context)!.translate(
                  'error_field_required',
                  params: [label],
                );
              }

              if (minLength != null &&
                  value!.length < minLength &&
                  (inputFormats == null || inputFormats.isEmpty) &&
                  required) {
                return MegaleiosLocalizations.of(context)!.translate(
                  'error_field_min_length',
                  params: [label, minLength],
                );
              }

              if (required &&
                  isPassword &&
                  value!.trim().replaceAll(' ', '').length < 6)
                return MegaleiosLocalizations.of(context)!.translate(
                  'error_field_min_length',
                  params: [6],
                );

              if (required &&
                  inputFormats != null &&
                  inputFormats.isNotEmpty &&
                  (value?.length ?? 0) < minLength!) {
                return MegaleiosLocalizations.of(context)!.translate(
                  'error_field_invalid',
                  params: [label],
                );
              }

              if (keyboardType == TextInputType.emailAddress &&
                  !EmailValidator.validate(value!) &&
                  required) {
                return MegaleiosLocalizations.of(context)!.translate(
                  'error_field_invalid',
                  params: [label],
                );
              }

              if (validator != null) {
                return validator(value!);
              }
              return null;
            },
          ),
        );
      },
    );
  }

  static Widget buildSelectableField(
    BuildContext context, {
    String? label,
    String? hint,
    TextEditingController? controller,
    TextCapitalization textCapitalization = TextCapitalization.none,
    InputDecoration? decoration,
    IconData? icon,
    bool required = false,
    bool hasPadding = true,
    bool enabled = true,
    bool showLabel = true,
    Function? onTap,
  }) {
    return buildField(
      context,
      label: label,
      textCapitalization: textCapitalization,
      hint: hint,
      controller: controller,
      required: required,
      enabled: enabled,
      hasPadding: hasPadding,
      maxLines: 1,
      onTap: onTap != null
          ? () {
              FocusScope.of(context).requestFocus(FocusNode());
              onTap();
            }
          : null,
      decoration: decoration != null
          ? decoration.copyWith(
              labelText: showLabel ? label : "",
              hintText: hint,
              suffixIcon: IconButton(
                  icon: Icon(
                    icon ?? FontAwesomeIcons.chevronDown,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 16,
                  ),
                  onPressed: () => {}),
            )
          : InputDecoration(
              labelText: showLabel ? label : "",
              hintText: '',
              suffixIcon: IconButton(
                icon: Icon(
                  icon ?? FontAwesomeIcons.chevronDown,
                  color: Colors.black,
                  size: 16,
                ),
                onPressed: () => {},
              ),
            ),
    );
  }

  static Widget buildDateField(
    BuildContext context, {
    String label = '',
    TextEditingController? controller,
    bool required = false,
    bool allowBefore = true,
    bool allowAfter = false,
    bool hasPadding = true,
    InputDecoration? decoration,
    Function(int)? onSavedInt,
    Function(String)? onSaved,
    Function()? onPressed,
    bool isReadOnly = false,
  }) {
    return buildField(context,
        controller: controller,
        inputFormats: [Formats.dateMaskFormatter],
        minLength: 10,
        required: required,
        hasPadding: hasPadding,
        keyboardType: TextInputType.number,
        decoration: decoration,
        onTap: onPressed,
        isReadOnly: isReadOnly,
        label: label, onSaved: (value) {
      onSavedInt!(
          Formats.dateFormat.parse(value!).millisecondsSinceEpoch ~/ 1000);

      onSaved!(value);
    }, validator: (value) {
      if (required && (value == null || value.trim().isEmpty)) {
        return MegaleiosLocalizations.of(context)!.translate(
          'error_field_required',
          params: [label],
        );
      }
      if (value!.length < 10) {
        return MegaleiosLocalizations.of(context)!.translate(
          'error_field_invalid',
          params: [label],
        );
      }
      final date = Formats.dateFormat.parse(value);

      final error = MyDateUtils.validate(context, value);
      if (error != null) {
        return error;
      }

      if (!allowBefore && (date.isBefore(DateTime.now()))) {
        return MegaleiosLocalizations.of(context)!.translate(
          'error_field_invalid',
          params: [label],
        );
      }

      if (!allowAfter && (date.isAfter(DateTime.now()))) {
        return MegaleiosLocalizations.of(context)!.translate(
          'error_field_invalid',
          params: [label],
        );
      }
      return null;
    });
  }

  static Widget buildYearField(
    BuildContext context, {
    String? label,
    TextEditingController? controller,
    bool required = true,
    bool allowBefore = true,
    bool allowAfter = false,
    Function(String?)? onSaved,
  }) {
    return buildField(context,
        controller: controller,
        inputFormats: [Formats.yearMaskFormatter],
        minLength: 4,
        required: required,
        keyboardType: TextInputType.number,
        label: label,
        onSaved: onSaved, validator: (value) {
      final date = Formats.yearMaskFormatter.parse(value);

      if (!allowBefore && (date == null || date.year < DateTime.now().year))
        return MegaleiosLocalizations.of(context)!.translate(
          'error_field_invalid',
          params: [label],
        );

      if (!allowAfter && (date == null || date.year > DateTime.now().year))
        return MegaleiosLocalizations.of(context)!.translate(
          'error_field_invalid',
          params: [label],
        );

      return null;
    });
  }

  static Widget buildCPFField(
    BuildContext context, {
    TextEditingController? controller,
    String? label,
    Function(String?)? onSaved,
    Function(String)? onChanged,
    TextInputType? keyboardType,
  }) {
    return TextFieldUtils.buildField(
      context,
      controller: controller,
      label: label,
      required: true,
      onSaved: onSaved,
      onChanged: onChanged,
      inputFormats: [Formats.cpfMaskFormatter],
      minLength: 14,
      keyboardType: TextInputType.number,
      validator: Validatorless.cpf('CPF inválido'),
    );
  }

  static Widget buildNameField(
    BuildContext context, {
    TextEditingController? controller,
    String? label,
    Function(String?)? onSaved,
    Function(String)? onChanged,
    bool enabled = true,
    TextCapitalization textCapitalization = TextCapitalization.none,
    bool isRequired = true,
  }) {
    return TextFieldUtils.buildField(
      context,
      enabled: enabled,
      controller: controller,
      textCapitalization: textCapitalization,
      label: label,
      required: isRequired,
      onSaved: onSaved,
      onChanged: onChanged,
      validator: (value) {
        if (!isRequired) {
          return null;
        }
        if (value == null || value.trim().isEmpty)
          return MegaleiosLocalizations.of(context)!
              .translate('error_field_required', params: [label]);
        if (value.split(' ').length < 2 || value.split(' ')[1].trim().isEmpty)
          return MegaleiosLocalizations.of(context)!
              .translate('error_field_invalid', params: [label]);
        return null;
      },
    );
  }
}
