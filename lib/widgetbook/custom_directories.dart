import 'package:fourtyninehub/widgetbook/flutter_markdown.dart';
import 'package:widgetbook/widgetbook.dart';

final customDirectories = <WidgetbookNode>[
  // Documentations Category
  WidgetbookCategory(
    name: 'Documentations',
    children: [
      WidgetbookUseCase(
        name: '01 Introduction.docs',
        builder: (context) => const MarkdownViewer(
          markdownFilePath: 'assets/markdown/docs/Introduction.md',
        ),
      ),
      WidgetbookUseCase(
        name: '02 Installation.docs',
        builder: (context) => const MarkdownViewer(
          markdownFilePath: 'assets/markdown/docs/Installation.md',
        ),
      ),
      WidgetbookUseCase(
        name: '03 Usage.docs',
        builder: (context) => const MarkdownViewer(
          markdownFilePath: 'assets/markdown/docs/Usage.md',
        ),
      ),
      WidgetbookUseCase(
        name: '04 Migration and Updates.docs',
        builder: (context) => const MarkdownViewer(
          markdownFilePath: 'assets/markdown/docs/MigrationAndUpdates.md',
        ),
      ),
    ],
  ), // UI Library Category
  WidgetbookCategory(
    name: 'UI Library',
    children: [
      // Forms Folder
      WidgetbookFolder(
        name: 'Forms',
        children: [
          //? Flexable Selector Widget

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
