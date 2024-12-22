import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import '../localized_annotation.dart';

class LocalizedGenerator extends GeneratorForAnnotation<Localized> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! EnumElement) {
      throw InvalidGenerationSourceError(
        '`@Localized` can only be used on enums.',
        element: element,
      );
    }

    // Get the `titles` list from the annotation
    final fields = annotation.peek('fields')?.listValue.map((value) {
      return value.toStringValue();
    }).toList();

    if (fields == null || fields.isEmpty) {
      throw InvalidGenerationSourceError(
        'Provide at least one field name.',
        element: element,
      );
    }
    final enumFields = element.fields.where((field) => field.isEnumConstant);
    final fieldsCode = fields.map((fieldToAdd) {
      final mapCode = enumFields.map((field) {
        final localeEntryName =
            '${element.name[0].toLowerCase()}${element.name.substring(1)}${field.name[0].toUpperCase()}${field.name.substring(1)}${fieldToAdd![0].toUpperCase()}${fieldToAdd.substring(1)}';
        return "\t\t${element.name}.${field.name}: AppLocalizations.of(context)!.$localeEntryName,";
      }).join('\n');

      return '''
      String $fieldToAdd(BuildContext context) => {
$mapCode
      }[this]!;
    ''';
    }).join('\n\n');

    return '''
    // GENERATED CODE (by MrPio) - DO NOT MODIFY BY HAND
    
    import 'package:flutter/material.dart';
    import 'package:flutter_gen/gen_l10n/app_localizations.dart';
    import '${buildStep.inputId.uri.pathSegments.last}'; 
    
    extension ${element.name}LocalizedExtension on ${element.name} {
$fieldsCode
    }
    ''';
  }
}

Builder localizedGenerator(BuilderOptions options) =>
    SharedPartBuilder([LocalizedGenerator()], 'localized');
