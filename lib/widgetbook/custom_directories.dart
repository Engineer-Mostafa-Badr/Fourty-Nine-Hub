import 'package:widgetbook/widgetbook.dart';

import 'component_usecases/text_input_widget_usecases.dart';
import 'docs_usecase.dart';

final customDirectories = <WidgetbookNode>[
  // Documentations Category
  WidgetbookCategory(
    name: 'Documentations',
    children: [
      WidgetbookFolder(
        name: 'Getting Started',
        children: [
          WidgetbookUseCase(
            name: '01 Introduction.docs',
            builder: introductionWidget,
          ),
          WidgetbookUseCase(
            name: '02 Installation.docs',
            builder: installationWidget,
          ),
          WidgetbookUseCase(
            name: '03 Usage.docs',
            builder: usageWidget,
          ),
          WidgetbookUseCase(
            name: '04 Migration and Updates.docs',
            builder: migrationAndUpdatesWidget,
          ),
        ],
      ),
    ],
  ), // Widgets Category
  WidgetbookCategory(
    name: 'Widgets',
    children: [
      // Forms Folder
      WidgetbookFolder(
        name: 'Forms',
        children: [
          //? Text Input Widget Widget
          WidgetbookComponent(
            name: 'Text Input Widget',
            useCases: [
              WidgetbookUseCase(
                name: 'Text Input Widget Description',
                builder: textInputWidgetDocumentation,
              ),
              WidgetbookUseCase(
                name: 'Basic Text Input UseCase',
                builder: basicTextInputWidget,
              ),
              WidgetbookUseCase(
                name: 'Card Number Input UseCase',
                builder: cardNumberInputWidget,
              ),
              WidgetbookUseCase(
                name: 'Custom Styled Text Input UseCase',
                builder: customStyledTextInputWidget,
              ),
              WidgetbookUseCase(
                name: 'Email Input UseCase',
                builder: emailInputWidget,
              ),
              WidgetbookUseCase(
                name: 'Multi-line Text Input UseCase',
                builder: multilineTextInputWidget,
              ),
              WidgetbookUseCase(
                name: 'Password Input UseCase',
                builder: passwordInputWidget,
              ),
            ],
          ),
          //? Wide Rounded Button

          //? International Phone Input

          //? OTP Input

          //? Text Input

          //? Nationality Selector
        ],
      ),
      // General Folder for all widgets
      WidgetbookFolder(
        name: 'General',
        children: [
          //? App Bottom Navigation Bar Widget

          //? AppTopBar Widget

          //? backgroundLogoPersonalImg Widget

          //? clickable Container Widget

          //? Color Container Widget

          //? Dual ActionButtons

          //? InfoDisplayWithTitleIcon

          //? Icon Background

          //? InfoDisplay

          //? PartnerItem

          //? RichTextSections

          //? RowTitlePrice

          //? SelectManagerItem

          //? StatusListWidget

          //? TappableIcon
        ],
      ),
      // Layout Folder
      WidgetbookFolder(
        name: 'Layout',
        children: [
          //? Info Layout Widget
          // WidgetbookComponent(
          //   name: 'InfoLayout Scaffold',
          //   useCases: [
          //     WidgetbookUseCase(
          //       name: 'Describtion.docs',
          //       builder: infoLayoutDescription,
          //     ),
          //     WidgetbookUseCase(
          //       name: 'InfoLayout UseCase',
          //       builder: infoLayoutScaffold,
          //     ),
          //   ],
          // ),
          //? Home Layout Widget
          // WidgetbookComponent(
          //   name: 'HomeLayoutScaffold',
          //   useCases: [
          //     WidgetbookUseCase(
          //       name: 'Describtion.docs',
          //       builder: homeLayoutDescribtion,
          //     ),
          //     WidgetbookUseCase(
          //       name: 'HomeLayout UseCase',
          //       builder: homeLayoutScaffold,
          //     ),
          //   ],
          // ),
          //? Detail Layout Widget
          // WidgetbookComponent(
          //   name: 'DetailLayoutScaffold',
          //   useCases: [
          //     WidgetbookUseCase(
          //       name: 'Describtion.docs',
          //       builder: detailLayoutDescription,
          //     ),
          //     WidgetbookUseCase(
          //       name: 'DetailLayout UseCase',
          //       builder: detailLayoutScaffold,
          //     ),
          //   ],
          // ),
          //? Auth Layout Widget
          // WidgetbookComponent(
          //   name: 'AuthLayoutScaffold',
          //   useCases: [
          //     WidgetbookUseCase(
          //       name: 'Describtion.docs',
          //       builder: authLayoutDescription,
          //     ),
          //     WidgetbookUseCase(
          //       name: 'AuthLayout UseCase',
          //       builder: authLayoutScaffold,
          //     ),
          //   ],
          // ),
        ],
      ),
    ],
  ),
];
