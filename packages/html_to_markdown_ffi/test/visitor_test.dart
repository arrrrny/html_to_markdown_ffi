import 'package:html_to_markdown_ffi/html_to_markdown.dart';
import 'package:test/test.dart';

class TestVisitor extends Visitor {
  final List<String> visited = [];

  @override
  VisitResult visitText(NodeContext ctx, String text) {
    visited.add(text);
    return VisitResult.continue_;
  }

  @override
  VisitResult visitElementStart(NodeContext ctx) {
    if (ctx.tagName == 'script' || ctx.tagName == 'style') {
      return VisitResult.skip;
    }
    return VisitResult.continue_;
  }
}

void main() {
  group('Visitor tests', () {
    test('default visitor does nothing', () {
      final result = convert('<p>Hello</p>');
      expect(result.content, contains('Hello'));
    });

    test('visitor can be instantiated', () {
      final visitor = TestVisitor();
      expect(visitor, isNotNull);
    });

    test('node context has required fields', () {
      final ctx = const NodeContext(
        nodeType: NodeType.element,
        tagName: 'p',
        depth: 0,
        indexInParent: 0,
        isInline: false,
      );
      expect(ctx.tagName, equals('p'));
      expect(ctx.nodeType, equals(NodeType.element));
    });

    test('visitResult values are correct', () {
      expect(VisitResult.continue_.toC, equals(0));
      expect(VisitResult.skip.toC, equals(1));
      expect(VisitResult.preserveHtml.toC, equals(2));
      expect(VisitResult.custom.toC, equals(3));
      expect(VisitResult.error.toC, equals(4));
    });

    test('visitResult toJson handles continue_', () {
      expect(VisitResult.continue_.toJson, equals('continue'));
      expect(VisitResult.fromJson('continue'), equals(VisitResult.continue_));
    });
  });
}
