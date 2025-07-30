// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:fourtyninehub/widgetbook/component_usecases/temp_usecase.dart'
    as _i2;
import 'package:fourtyninehub/widgetbook/component_usecases/text_input_widget_usecases.dart'
    as _i3;
import 'package:fourtyninehub/widgetbook/docs_usecase.dart' as _i4;
import 'package:widgetbook/widgetbook.dart' as _i1;

final directories = <_i1.WidgetbookNode>[
  _i1.WidgetbookLeafComponent(
    name: 'Type',
    useCase: _i1.WidgetbookUseCase(
      name: 'Custom UseCase',
      builder: _i2.tempUseCaseWidget,
    ),
  ),
  _i1.WidgetbookFolder(
    name: 'core',
    children: [
      _i1.WidgetbookFolder(
        name: 'widget',
        children: [
          _i1.WidgetbookFolder(
            name: 'text_input',
            children: [
              _i1.WidgetbookComponent(
                name: 'TextInputWidget',
                useCases: [
                  _i1.WidgetbookUseCase(
                    name: 'Basic Text Input',
                    builder: _i3.basicTextInputWidget,
                  ),
                  _i1.WidgetbookUseCase(
                    name: 'CVC Input',
                    builder: _i3.cvcInputWidget,
                  ),
                  _i1.WidgetbookUseCase(
                    name: 'Card Expiry Input',
                    builder: _i3.cardExpiryInputWidget,
                  ),
                  _i1.WidgetbookUseCase(
                    name: 'Card Number Input',
                    builder: _i3.cardNumberInputWidget,
                  ),
                  _i1.WidgetbookUseCase(
                    name: 'Custom Styled Text Input',
                    builder: _i3.customStyledTextInputWidget,
                  ),
                  _i1.WidgetbookUseCase(
                    name: 'Disabled Text Input',
                    builder: _i3.disabledTextInputWidget,
                  ),
                  _i1.WidgetbookUseCase(
                    name: 'Email Input',
                    builder: _i3.emailInputWidget,
                  ),
                  _i1.WidgetbookUseCase(
                    name: 'Email or Phone Input',
                    builder: _i3.emailOrPhoneInputWidget,
                  ),
                  _i1.WidgetbookUseCase(
                    name: 'Multi-line Text Input',
                    builder: _i3.multilineTextInputWidget,
                  ),
                  _i1.WidgetbookUseCase(
                    name: 'Name Input',
                    builder: _i3.nameInputWidget,
                  ),
                  _i1.WidgetbookUseCase(
                    name: 'Number Input',
                    builder: _i3.numberInputWidget,
                  ),
                  _i1.WidgetbookUseCase(
                    name: 'Optional Text Input',
                    builder: _i3.optionalTextInputWidget,
                  ),
                  _i1.WidgetbookUseCase(
                    name: 'Password Input',
                    builder: _i3.passwordInputWidget,
                  ),
                  _i1.WidgetbookUseCase(
                    name: 'Phone Number Input',
                    builder: _i3.phoneInputWidget,
                  ),
                  _i1.WidgetbookUseCase(
                    name: 'Read Only Text Input',
                    builder: _i3.readOnlyTextInputWidget,
                  ),
                ],
              )
            ],
          )
        ],
      )
    ],
  ),
  _i1.WidgetbookFolder(
    name: 'widgetbook',
    children: [
      _i1.WidgetbookComponent(
        name: 'MarkdownViewer',
        useCases: [
          _i1.WidgetbookUseCase(
            name: '01 Introduction.docs',
            builder: _i4.introductionWidget,
          ),
          _i1.WidgetbookUseCase(
            name: '02 Installation.docs',
            builder: _i4.installationWidget,
          ),
          _i1.WidgetbookUseCase(
            name: '03 Usage.docs',
            builder: _i4.usageWidget,
          ),
          _i1.WidgetbookUseCase(
            name: '04 Migration and Updates.docs',
            builder: _i4.migrationAndUpdatesWidget,
          ),
          _i1.WidgetbookUseCase(
            name: 'Custom Description',
            builder: _i2.tempDescriptionWidget,
          ),
          _i1.WidgetbookUseCase(
            name: 'TextInputWidget Documentation',
            builder: _i3.textInputWidgetDocumentation,
          ),
        ],
      )
    ],
  ),
];
