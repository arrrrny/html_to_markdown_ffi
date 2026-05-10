import 'package:html_to_markdown_ffi/html_to_markdown.dart';
import 'package:test/test.dart';

void main() {
  group('Real-world HTML', () {
    test('news article', () {
      final html = '''
<!DOCTYPE html>
<html>
<head><title>Breaking News</title></head>
<body>
  <article>
    <h1>Major Event Occurs</h1>
    <p class="byline">By <strong>Jane Doe</strong></p>
    <p>The long-awaited event finally happened today.</p>
    <blockquote>
      <p>This is a historic moment.</p>
    </blockquote>
    <ul>
      <li>Key point one</li>
      <li>Key point two</li>
    </ul>
    <p>For more details, visit <a href="https://example.com">our website</a>.</p>
  </article>
</body>
</html>''';
      final result = convert(html);
      expect(result.content, contains('# Major Event Occurs'));
      expect(result.content, contains('Jane Doe'));
      expect(result.content, contains('long-awaited'));
    });

    test('GitHub README style', () {
      final html = '''
<h1>Project Name</h1>
<p>A description of the project.</p>
<h2>Installation</h2>
<pre><code>npm install package-name</code></pre>
<h2>Usage</h2>
<pre><code class="language-javascript">
const app = require("package-name");
app.run();
</code></pre>
<h2>Contributing</h2>
<p>Pull requests welcome.</p>
''';
      final result = convert(html);
      expect(result.content, contains('# Project Name'));
      expect(result.content, contains('## Installation'));
      expect(result.content, contains('npm install'));
      expect(result.content, contains('## Contributing'));
    });

    test('blog post with embedded media', () {
      final html = '''
<article>
  <h1>My Blog Post</h1>
  <p>Here is an image:</p>
  <img src="photo.jpg" alt="A beautiful photo">
  <p>And here is a video:</p>
  <video src="clip.mp4"></video>
  <p>Thanks for reading!</p>
</article>''';
      final result = convert(html);
      expect(result.content, contains('My Blog Post'));
      expect(result.content, contains('photo.jpg'));
      expect(result.content, contains('beautiful photo'));
    });

    test('e-commerce product page', () {
      final html = '''
<div class="product">
  <h1>Widget Pro</h1>
  <p class="price">\$19.99</p>
  <p class="description">The best widget you will ever buy.</p>
  <table>
    <tr><th>Spec</th><th>Value</th></tr>
    <tr><td>Size</td><td>Large</td></tr>
    <tr><td>Color</td><td>Blue</td></tr>
  </table>
</div>''';
      final result = convert(html);
      expect(result.content, contains('Widget Pro'));
      expect(result.content, contains('19.99'));
      expect(result.content, contains('Spec'));
      expect(result.content, contains('Value'));
    });
  });
}
