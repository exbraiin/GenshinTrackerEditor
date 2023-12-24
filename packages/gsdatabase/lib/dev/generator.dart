import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:gsdatabase/src/models/gs_model.dart';
import 'package:source_gen/source_gen.dart';

Builder generatorBuilder(BuilderOptions options) =>
    SharedPartBuilder([BuilderGeneratorGen()], 'builder');

class BuilderGeneratorGen extends GeneratorForAnnotation<BuilderGenerator> {
  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is! ClassElement) {
      throw 'invalid element';
    }

    if (!element.isAbstract) {
      throw 'Not an abstract class!';
    }

    final className = element.displayName;
    if (!className.startsWith('_')) {
      throw 'Class Name does not start with "_"';
    }

    final fields = [
      ...element.allSupertypes.expand((e) => e.accessors),
      ...element.accessors,
    ]
        .whereType<PropertyAccessorElement>()
        .where((element) => _hasBuilderWire(element));

    final name = _classNameFromInterface(className);
    final buffer = StringBuffer()
      ..writeln('class $name extends GsModel<$name> with $className{')
      ..writeAll(_fields(element, fields))
      ..writeAll(_constructor(element, fields))
      ..writeAll(_constructorJson(element, fields))
      ..writeAll(_copyWith(element, fields))
      ..writeAll(_toJsonMap(element, fields))
      ..writeln('}');

    return buffer.toString();
  }

  String _classNameFromInterface(String name) {
    return name.substring(1);
  }

  String _paramName(DartType type) {
    const interfaceName = ['_Gs', '_Gi'];
    final typeName = type.getDisplayString(withNullability: false);
    if (interfaceName.any((e) => typeName.startsWith(e))) {
      return _classNameFromInterface(typeName);
    } else if (type.isDartCoreList && type is ParameterizedType) {
      final param = type.typeArguments.firstOrNull;
      final paramName = param?.getDisplayString(withNullability: false);
      if (interfaceName.any((e) => paramName?.startsWith(e) ?? false)) {
        return 'List<${_classNameFromInterface(paramName!)}>';
      }
    }
    return typeName;
  }

  Iterable<String> _fields(
    Element element,
    Iterable<FunctionTypedElement> fields,
  ) sync* {
    yield* fields.map((e) {
      final typeName = _paramName(e.returnType);
      return '@override\nfinal $typeName ${e.displayName};';
    });
  }

  Iterable<String> _constructor(
    Element element,
    Iterable<FunctionTypedElement> fields,
  ) sync* {
    final name = _classNameFromInterface(element.displayName);
    yield '/// Creates a new [$name] instance.\n';
    yield '$name({';
    yield* fields.map((e) => 'required this.${e.displayName},');
    yield '});';
  }

  String _dateToString(String name) {
    return '$name.toString()';
  }

  ({String getter, String setter}) _getJsonGetter(PropertyAccessorElement e) {
    final type = e.returnType;
    final wire = _getBuilderWire(e).wire;
    final typeName = type.getDisplayString(withNullability: false);
    if (type.isDartCoreInt) {
      return (
        setter: e.displayName,
        getter: 'm[\'$wire\'] as int? ?? 0',
      );
    }
    if (type.isDartCoreBool) {
      return (
        setter: e.displayName,
        getter: 'm[\'$wire\'] as bool? ?? false',
      );
    }

    if (type.isDartCoreDouble) {
      return (
        setter: e.displayName,
        getter: 'm[\'$wire\'] as double? ?? 0',
      );
    }
    if (type.isDartCoreString) {
      return (
        setter: e.displayName,
        getter: 'm[\'$wire\'] as String? ?? \'\'',
      );
    }
    if (type.isDartCoreList) {
      if (typeName == 'List<int>') {
        return (
          setter: e.displayName,
          getter: '(m[\'$wire\'] as List? ?? const []).cast<int>()',
        );
      }
      if (typeName == 'List<double>') {
        return (
          setter: e.displayName,
          getter: '(m[\'$wire\'] as List? ?? const []).cast<double>()',
        );
      }
      if (typeName == 'List<String>') {
        return (
          setter: e.displayName,
          getter: '(m[\'$wire\'] as List? ?? const []).cast<String>()',
        );
      }
      if (typeName == 'List<DateTime>') {
        return (
          setter: '${e.displayName}.map((e) => ${_dateToString('e')}).toList()',
          getter: '((m[\'$wire\'] as List? ?? const []).cast<String>())'
              '.map((e) => DateTime.tryParse(e) ?? DateTime(0)).toList()',
        );
      }

      if (type is ParameterizedType) {
        final arg = type.typeArguments.firstOrNull;
        if (arg != null) {
          final argName = arg.getDisplayString(withNullability: false);
          final name = _classNameFromInterface(argName);
          if (TypeChecker.fromRuntime(GeEnum).isAssignableFromType(arg)) {
            return (
              setter: '${e.displayName}.map((e) => e.id).toList()',
              getter: '$argName.values.fromIds'
                  '((m[\'$wire\'] as List? ?? const []).cast<String>())',
            );
          }

          if (TypeChecker.fromRuntime(GsModel).isAssignableFromType(arg)) {
            return (
              setter: '${e.displayName}.map((e) => e.toMap()).toList()',
              getter: '(m[\'$wire\'] as List? ?? const [])'
                  '.map((e) => $name.fromJson(e)).toList()',
            );
          }
        }
      }
    }
    if (type.isDartCoreMap) {
      final types = typeName.substring(3);
      return (
        setter: e.displayName,
        getter: '(m[\'$wire\'] as Map? ?? const {}).cast$types()',
      );
    }

    if (typeName == 'DateTime') {
      return (
        setter: _dateToString(e.displayName),
        getter: 'DateTime.tryParse(m[\'$wire\'].toString()) ?? DateTime(0)',
      );
    }

    final name = _classNameFromInterface(typeName);
    if (TypeChecker.fromRuntime(GsModel).isAssignableFromType(type)) {
      return (
        setter: '${e.displayName}.toMap()',
        getter: '$name.fromJson(m[\'$wire\'])',
      );
    }
    if (TypeChecker.fromRuntime(GeEnum).isAssignableFromType(type)) {
      return (
        setter: '${e.displayName}.id',
        getter: '$typeName.values.fromId(m[\'$wire\'])',
      );
    }
    return (setter: e.displayName, getter: 'm[\'$wire\']');
  }

  Iterable<String> _constructorJson(
    Element element,
    Iterable<PropertyAccessorElement> fields,
  ) sync* {
    final name = _classNameFromInterface(element.displayName);
    yield '/// Creates a new [$name] instance from the given map.\n';
    yield '$name.fromJson(JsonMap m):';
    yield fields.map((e) {
      return '${e.displayName}= ${_getJsonGetter(e).getter}';
    }).join(',');
    yield ';';
  }

  Iterable<String> _copyWith(
    Element element,
    Iterable<PropertyAccessorElement> fields,
  ) sync* {
    final name = _classNameFromInterface(element.displayName);
    yield '/// Copies this model with the given parameters.\n';
    yield '@override\n';
    yield '$name copyWith({';
    yield* fields.map((e) {
      final typeName = _paramName(e.returnType);
      return '$typeName? ${e.displayName},';
    });
    yield '}) {';
    yield 'return $name(';
    yield* fields.map((e) {
      return '${e.displayName}: ${e.displayName} ?? this.${e.displayName},';
    });
    yield ');';
    yield '}';
  }

  Iterable<String> _toJsonMap(
    Element element,
    Iterable<PropertyAccessorElement> fields,
  ) sync* {
    yield '/// Creates a [JsonMap] from this model.\n';
    yield '@override\n';
    yield 'JsonMap toMap(){';
    yield 'return {';
    yield* fields.map((e) {
      final wire = _getBuilderWire(e).wire;
      return '\'$wire\': ${_getJsonGetter(e).setter},';
    });
    yield '};';
    yield '}';
  }

  bool _hasBuilderWire(PropertyAccessorElement element) {
    final checker = TypeChecker.fromRuntime(BuilderWire);
    return checker.hasAnnotationOf(element);
  }

  BuilderWire _getBuilderWire(PropertyAccessorElement element) {
    final checker = TypeChecker.fromRuntime(BuilderWire);
    final annotation = checker.firstAnnotationOf(element);
    if (annotation == null) return BuilderWire(element.displayName);
    final reader = ConstantReader(annotation);
    final wire = reader.peek('wire')?.stringValue ?? element.displayName;
    return BuilderWire(wire);
  }
}
