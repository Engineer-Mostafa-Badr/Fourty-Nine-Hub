import 'package:widgetbook/widgetbook.dart';

import 'component_usecases/call_message_buttons_usecase.dart';
import 'component_usecases/counter_widget_usecase.dart';
import 'component_usecases/custom_circular_progress_indicator_usecase.dart';
import 'component_usecases/custom_drop_down_usecase.dart';
import 'component_usecases/custom_expanded_input_widget_usecase.dart';
import 'component_usecases/custom_scaffold_usecase.dart';
import 'component_usecases/text_input_widget_usecases.dart';
import 'getting_start_docs/docs_usecase.dart';

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
          //? Call Message Buttons
          WidgetbookComponent(
            name: 'Call Message Buttons',
            useCases: [
              WidgetbookUseCase(
                name: 'CallMessageButtonsWidget Documentation',
                builder: callMessageButtonsWidgetDocumentation,
              ),
              WidgetbookUseCase(
                name: 'Call Message Buttons UseCase',
                builder: basicCallMessageButtonsWidget,
              ),
              WidgetbookUseCase(
                name: 'Call Message Buttons Sizes',
                builder: callMessageButtonsSizesWidget,
              ),
              WidgetbookUseCase(
                name: 'Call Message Buttons States',
                builder: callMessageButtonsStatesWidget,
              ),
            ],
          ),

          //? Counter Widget
          WidgetbookComponent(
            name: 'Counter Widget',
            useCases: [
              WidgetbookUseCase(
                name: 'Counter Widget Documentation',
                builder: counterWidgetDocumentation,
              ),
              WidgetbookUseCase(
                name: 'Counter Widget',
                builder: counterWidgetWidget,
              ),
              WidgetbookUseCase(
                name: 'Counter Widget States',
                builder: counterWidgetStatesWidget,
              ),
            ],
          ),

          //? Custom Circular Progress Indicator
          WidgetbookComponent(
            name: 'Custom Circular Progress Indicator',
            useCases: [
              WidgetbookUseCase(
                name: 'Custom Circular Progress Indicator Documentation',
                builder: customCircularProgressIndicatorDocumentation,
              ),
              WidgetbookUseCase(
                name: 'Custom Circular Progress Indicator UseCase',
                builder: customCircularProgressIndicatorWidget,
              ),
            ],
          ),
          //? Custom Drop Down Widget
          WidgetbookComponent(
            name: 'Custom Drop Down Widget',
            useCases: [
              WidgetbookUseCase(
                name: 'Custom Drop Down Widget Documentation',
                builder: customDropDownDocumentation,
              ),
              WidgetbookUseCase(
                name: 'Custom Drop Down Widget UseCase',
                builder: customDropDownWidget,
              ),
            ],
          ),
          //? Custom Expanded Input Widget
          WidgetbookComponent(
            name: 'Custom Expanded Input Widget',
            useCases: [
              WidgetbookUseCase(
                name: 'Custom Expanded Input Widget Documentation',
                builder: expandedInputWidgetDocumentation,
              ),
              WidgetbookUseCase(
                name: 'Custom Expanded Input Widget UseCase',
                builder: expandedInputWidgetWidget,
              ),
            ],
          ),

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
          //? Custom Scaffold Widget
          WidgetbookComponent(
            name: 'Custom Scaffold Widget',
            useCases: [
              WidgetbookUseCase(
                name: 'Custom Scaffold Widget Documentation',
                builder: customScaffoldDocumentation,
              ),
              WidgetbookUseCase(
                name: 'Custom Scaffold Basic UseCase',
                builder: customScaffoldBasicWidget,
              ),
              WidgetbookUseCase(
                name: 'Custom Scaffold Layout Variations',
                builder: customScaffoldLayoutVariationsWidget,
              ),
              WidgetbookUseCase(
                name: 'Custom Scaffold With FAB',
                builder: customScaffoldWithFABWidget,
              ),
            ],
          ),
          //? Info Layout Widget

          //? Home Layout Widget

          //? Detail Layout Widget

          //? Auth Layout Widget
        ],
      ),
    ],
  ),
];
