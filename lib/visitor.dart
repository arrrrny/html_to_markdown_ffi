import 'models/enums.dart';

/// Context information passed to each visitor callback.
class NodeContext {
  final NodeType nodeType;
  final String tagName;
  final int depth;
  final int indexInParent;
  final String? parentTag;
  final bool isInline;

  const NodeContext({
    required this.nodeType,
    required this.tagName,
    required this.depth,
    required this.indexInParent,
    this.parentTag,
    required this.isInline,
  });
}

/// Abstract visitor for intercepting HTML element processing.
///
/// Override individual methods to customize conversion behavior for specific
/// HTML elements. Each method returns a [VisitResult]:
/// - [VisitResult.continue_]: Use default Markdown conversion.
/// - [VisitResult.skip]: Skip this element entirely (no output).
/// - [VisitResult.preserveHtml]: Keep the original HTML verbatim.
/// - [VisitResult.custom]: Provide custom Markdown output.
/// - [VisitResult.error]: Abort conversion with an error.
abstract class Visitor {
  VisitResult visitElementStart(NodeContext ctx) => VisitResult.continue_;
  VisitResult visitElementEnd(NodeContext ctx, String output) =>
      VisitResult.continue_;
  VisitResult visitText(NodeContext ctx, String text) => VisitResult.continue_;
  VisitResult visitLink(
          NodeContext ctx, String href, String text, String? title) =>
      VisitResult.continue_;
  VisitResult visitImage(
          NodeContext ctx, String src, String alt, String? title) =>
      VisitResult.continue_;
  VisitResult visitHeading(
          NodeContext ctx, int level, String text, String? id) =>
      VisitResult.continue_;
  VisitResult visitCodeBlock(
          NodeContext ctx, String? lang, String code) =>
      VisitResult.continue_;
  VisitResult visitCodeInline(NodeContext ctx, String code) =>
      VisitResult.continue_;
  VisitResult visitListItem(
          NodeContext ctx, bool ordered, String marker, String text) =>
      VisitResult.continue_;
  VisitResult visitListStart(NodeContext ctx, bool ordered) =>
      VisitResult.continue_;
  VisitResult visitListEnd(
          NodeContext ctx, bool ordered, String output) =>
      VisitResult.continue_;
  VisitResult visitTableStart(NodeContext ctx) => VisitResult.continue_;
  VisitResult visitTableRow(
          NodeContext ctx, List<String> cells, bool isHeader) =>
      VisitResult.continue_;
  VisitResult visitTableEnd(NodeContext ctx, String output) =>
      VisitResult.continue_;
  VisitResult visitBlockquote(
          NodeContext ctx, String content, int depth) =>
      VisitResult.continue_;
  VisitResult visitStrong(NodeContext ctx, String text) =>
      VisitResult.continue_;
  VisitResult visitEmphasis(NodeContext ctx, String text) =>
      VisitResult.continue_;
  VisitResult visitStrikethrough(NodeContext ctx, String text) =>
      VisitResult.continue_;
  VisitResult visitUnderline(NodeContext ctx, String text) =>
      VisitResult.continue_;
  VisitResult visitSubscript(NodeContext ctx, String text) =>
      VisitResult.continue_;
  VisitResult visitSuperscript(NodeContext ctx, String text) =>
      VisitResult.continue_;
  VisitResult visitMark(NodeContext ctx, String text) =>
      VisitResult.continue_;
  VisitResult visitLineBreak(NodeContext ctx) => VisitResult.continue_;
  VisitResult visitHorizontalRule(NodeContext ctx) => VisitResult.continue_;
  VisitResult visitCustomElement(
          NodeContext ctx, String tagName, String html) =>
      VisitResult.continue_;
  VisitResult visitDefinitionListStart(NodeContext ctx) =>
      VisitResult.continue_;
  VisitResult visitDefinitionTerm(NodeContext ctx, String text) =>
      VisitResult.continue_;
  VisitResult visitDefinitionDescription(NodeContext ctx, String text) =>
      VisitResult.continue_;
  VisitResult visitDefinitionListEnd(NodeContext ctx, String output) =>
      VisitResult.continue_;
  VisitResult visitForm(NodeContext ctx, String action, String method) =>
      VisitResult.continue_;
  VisitResult visitInput(
          NodeContext ctx, String inputType, String name, String? value) =>
      VisitResult.continue_;
  VisitResult visitButton(NodeContext ctx, String text) =>
      VisitResult.continue_;
  VisitResult visitAudio(NodeContext ctx, String src) =>
      VisitResult.continue_;
  VisitResult visitVideo(NodeContext ctx, String src) =>
      VisitResult.continue_;
  VisitResult visitIframe(NodeContext ctx, String src) =>
      VisitResult.continue_;
  VisitResult visitDetails(NodeContext ctx, bool open) =>
      VisitResult.continue_;
  VisitResult visitSummary(NodeContext ctx, String text) =>
      VisitResult.continue_;
  VisitResult visitFigureStart(NodeContext ctx) => VisitResult.continue_;
  VisitResult visitFigcaption(NodeContext ctx, String text) =>
      VisitResult.continue_;
  VisitResult visitFigureEnd(NodeContext ctx, String output) =>
      VisitResult.continue_;
}
