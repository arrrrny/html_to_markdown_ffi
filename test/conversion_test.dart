import 'package:html_to_markdown_ffi/html_to_markdown.dart';
import 'package:test/test.dart';

void main() {
  group('Conversion tests', () {
    group('Headings', () {
      test('h1', () {
        final result = convert('<h1>Heading 1</h1>');
        expect(result.content, contains('# Heading 1'));
      });

      test('h2', () {
        final result = convert('<h2>Heading 2</h2>');
        expect(result.content, contains('## Heading 2'));
      });

      test('h3', () {
        final result = convert('<h3>Heading 3</h3>');
        expect(result.content, contains('### Heading 3'));
      });

      test('h6', () {
        final result = convert('<h6>Heading 6</h6>');
        expect(result.content, contains('###### Heading 6'));
      });
    });

    group('Inline formatting', () {
      test('bold', () {
        final result =
            convert('<p>This is <strong>bold</strong> text.</p>');
        expect(result.content, contains('**bold**'));
      });

      test('italic', () {
        final result = convert('<p>This is <em>italic</em> text.</p>');
        expect(result.content, contains('*italic*'));
      });

      test('bold and italic', () {
        final result = convert(
            '<p>This is <strong>bold</strong> and <em>italic</em>.</p>');
        expect(result.content, contains('**bold**'));
        expect(result.content, contains('*italic*'));
      });

      test('inline code', () {
        final result = convert('<p>Use <code>print()</code> function.</p>');
        expect(result.content, contains('`print()`'));
      });

      test('strikethrough', () {
        final result = convert('<p><del>deleted</del> text.</p>');
        expect(result.content, contains('~~deleted~~'));
      });
    });

    group('Links', () {
      test('link with href', () {
        final result =
            convert('<a href="https://example.com">Example</a>');
        expect(result.content, contains('Example'));
        expect(result.content, contains('https://example.com'));
      });

      test('link with title', () {
        final result = convert(
            '<a href="/page" title="Go to page">Page</a>');
        expect(result.content, contains('Page'));
      });
    });

    group('Images', () {
      test('image with src and alt', () {
        final result =
            convert('<img src="photo.jpg" alt="A photo">');
        expect(result.content, contains('photo.jpg'));
        expect(result.content, contains('A photo'));
      });
    });

    group('Lists', () {
      test('unordered list', () {
        final result =
            convert('<ul><li>Item 1</li><li>Item 2</li></ul>');
        expect(result.content, contains('- Item 1'));
        expect(result.content, contains('- Item 2'));
      });

      test('ordered list', () {
        final result =
            convert('<ol><li>First</li><li>Second</li></ol>');
        expect(result.content, contains('1. First'));
        expect(result.content, contains('2. Second'));
      });

      test('nested list', () {
        final result = convert(
            '<ul><li>Parent<ul><li>Child</li></ul></li></ul>');
        expect(result.content, contains('- Parent'));
        expect(result.content, contains('- Child'));
      });
    });

    group('Blockquotes', () {
      test('single blockquote', () {
        final result =
            convert('<blockquote><p>Quoted text</p></blockquote>');
        expect(result.content, contains('> Quoted text'));
      });

      test('nested blockquote', () {
        final result = convert(
            '<blockquote><p>Outer</p><blockquote><p>Inner</p></blockquote></blockquote>');
        expect(result.content, contains('> Outer'));
        expect(result.content, contains('> > Inner'));
      });
    });

    group('Code blocks', () {
      test('fenced code block', () {
        final result = convert(
            '<pre><code class="language-dart">void main() {}</code></pre>');
        // The converter outputs indented code for <pre><code>
        expect(result.content, contains('void main()'));
      });

      test('inline code', () {
        final result = convert('<code>const x = 1;</code>');
        expect(result.content, contains('`const x = 1;`'));
      });
    });

    group('Tables', () {
      test('simple table', () {
        final result = convert(
            '<table><tr><th>Name</th><th>Age</th></tr>'
            '<tr><td>Alice</td><td>30</td></tr></table>');
        expect(result.content, contains('Name'));
        expect(result.content, contains('Alice'));
      });
    });

    group('Line breaks and rules', () {
      test('line break', () {
        final result = convert('<p>Line 1<br>Line 2</p>');
        expect(result.content, contains('Line 1'));
        expect(result.content, contains('Line 2'));
      });

      test('horizontal rule', () {
        final result = convert('<hr>');
        expect(result.content, contains('---'));
      });
    });

    group('HTML entities', () {
      test('ampersand', () {
        final result = convert('<p>AT&amp;T</p>');
        expect(result.content, contains('AT&T'));
      });

      test('less than and greater than', () {
        final result = convert('<p>1 &lt; 2 &gt; 0</p>');
        expect(result.content, contains('1 < 2 > 0'));
      });
    });

    group('Semantic elements', () {
      test('strong vs b', () {
        final resultStrong = convert('<strong>important</strong>');
        final resultB = convert('<b>important</b>');
        expect(resultStrong.content, contains('**important**'));
        expect(resultB.content, contains('**important**'));
      });

      test('em vs i', () {
        final resultEm = convert('<em>emphasis</em>');
        final resultI = convert('<i>emphasis</i>');
        expect(resultEm.content, contains('*emphasis*'));
        expect(resultI.content, contains('*emphasis*'));
      });
    });
  });
}
