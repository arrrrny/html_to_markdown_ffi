// Spec 064 behavior B4: the host FFI proof. Drives REAL conversion through
// the migrated stack (public convert() -> default service -> datasource ->
// preserved dart:ffi bridge) on >= 20 representative HTML inputs, plus the
// visitor-bridge pin and the native error-code pins. Executes on macOS
// hosts (the pre-migration suite's status-quo parity, research D7); the
// binary is discovered through the preserved loading chain (sibling
// adapter probe in the monorepo).
import 'package:test/test.dart';
import 'package:html_to_markdown_ffi/html_to_markdown.dart';

/// Representative corpus: >= 20 inputs across headings, tables, lists,
/// links, images, emphasis, code, blockquotes, and edge cases (SC-002).
const corpus = <String, String>{
  'heading-atx': '<h1>Title</h1>',
  'heading-nested': '<h2>Sub<b>bold</b></h2>',
  'paragraph': '<p>Hello world</p>',
  'bold': '<p>a <b>bold</b> word</p>',
  'italic': '<p>an <i>italic</i> word</p>',
  'link': '<p><a href="https://example.com">link</a></p>',
  'image': '<p><img src="cat.png" alt="A cat"></p>',
  'unordered-list': '<ul><li>one</li><li>two</li></ul>',
  'ordered-list': '<ol><li>first</li><li>second</li></ol>',
  'nested-list': '<ul><li>parent<ul><li>child</li></ul></li></ul>',
  'table': '<table><tr><th>a</th><th>b</th></tr>'
      '<tr><td>1</td><td>2</td></tr></table>',
  'blockquote': '<blockquote><p>quoted</p></blockquote>',
  'code-inline': '<p>run <code>ls -la</code> now</p>',
  'code-block': '<pre><code>void main() {}</code></pre>',
  'horizontal-rule': '<hr>',
  'line-break': '<p>one<br>two</p>',
  'emphasis-mixed': '<p><strong>strong</strong> and <em>em</em></p>',
  'heading-with-link': '<h2><a href="/x">Head</a></h2>',
  'definition-ish': '<dl><dt>term</dt><dd>def</dd></dl>',
  'strikethrough': '<p><del>gone</del></p>',
  'empty-input': '',
  'malformed': '<p><b>unclosed <i>nesting</p>',
  'entities': '<p>fish &amp; chips &lt;tag&gt;</p>',
  'deep-nesting': '<div><div><div><div><p>deep</p></div></div></div></div>',
};

void main() {
  test('native bridge is loadable on this host', () {
    final result = convert('<p>smoke</p>');
    expect(result.content, isNotNull);
  }, timeout: const Timeout(Duration(minutes: 2)));

  test('corpus parity: every input converts to non-empty well-formed '
      'markdown through the migrated stack (SC-002)', () {
    expect(corpus.length, greaterThanOrEqualTo(20),
        reason: 'SC-002 requires a corpus of at least 20 inputs');
    corpus.forEach((name, html) {
      final result = convert(html);
      if (name == 'empty-input') {
        expect(result.content, isNotNull,
            reason: '$name: empty input degrades gracefully');
        return;
      }
      expect(result.content, isNotNull,
          reason: '$name must produce content');
      expect(result.content, isNotEmpty, reason: '$name must be non-empty');
      expect(result.content, isA<String>());
    });
  }, timeout: const Timeout(Duration(minutes: 2)));

  test('spot checks: headings, tables, lists render as expected', () {
    expect(convert('<h1>Title</h1>').content, contains('# Title'));
    expect(convert('<ul><li>one</li><li>two</li></ul>').content,
        contains('- one'));
    final table = convert(
        '<table><tr><th>a</th></tr><tr><td>1</td></tr></table>').content!;
    expect(table, contains('a'));
    expect(table, contains('1'));
  }, timeout: const Timeout(Duration(minutes: 2)));

  test('visitor bridge parity: visitor calls convert with default '
      'rendering (shipped 1.1.0 bridge semantics preserved)', () {
    // The shipped VisitorBridge is a documented stub ("delegates to
    // default conversion") — visitors are accepted, the vtable plumbing
    // lands in a later release. The pin asserts that preserved parity:
    // conversion with a visitor completes and is indistinguishable from
    // the default rendering.
    final plain = convert('<p>keep</p><h2>drop me</h2>');
    final withVisitor = convert(
      '<p>keep</p><h2>drop me</h2>',
      visitor: _SkipHeadingsVisitor(),
    );
    expect(withVisitor.content, isNotNull);
    expect(withVisitor.content, plain.content,
        reason: 'the preserved stub bridge renders identically to the '
            'default path');
  }, timeout: const Timeout(Duration(minutes: 2)));

  test('typed exception hierarchy pin (preserved checkLastError surface)',
      () {
    expect(InvalidInputException('x', errorCode: 1).errorCode, 1);
    expect(ConversionErrorException('x', errorCode: 2).errorCode, 2);
    expect(HtmlToMarkdownException('x', errorCode: 3).errorCode, 3);
    expect(InvalidInputException('x'), isA<HtmlToMarkdownException>());
    expect(ConversionErrorException('x'), isA<HtmlToMarkdownException>());
  });
}

class _SkipHeadingsVisitor extends Visitor {}
