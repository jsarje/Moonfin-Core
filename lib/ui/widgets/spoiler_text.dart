import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Wraps overview/synopsis text so that it can be hidden behind a tappable
/// spoiler warning until the user chooses to reveal it. Used for movie,
/// season, and episode descriptions when the corresponding "hide spoilers"
/// preference is enabled and the item has not been fully watched.
///
/// By default renders a plain [Text] widget with [text] (matching the
/// signature most call sites already use). Pass [builder] instead when the
/// revealed content needs a richer widget (e.g. an expandable biography).
class SpoilerText extends StatefulWidget {
  final String text;
  final bool hidden;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final Widget Function(BuildContext context, String text)? builder;

  const SpoilerText({
    super.key,
    required this.text,
    required this.hidden,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.builder,
  });

  @override
  State<SpoilerText> createState() => _SpoilerTextState();
}

class _SpoilerTextState extends State<SpoilerText> {
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.hidden || _revealed) {
      if (widget.builder != null) {
        return widget.builder!(context, widget.text);
      }
      return Text(
        widget.text,
        style: widget.style,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        overflow: widget.overflow,
      );
    }

    final l10n = AppLocalizations.of(context);
    final placeholder = '${l10n.spoilerHiddenPlaceholder} · ${l10n.tapToRevealSpoiler}';
    final placeholderStyle = widget.style != null
        ? widget.style!.copyWith(fontStyle: FontStyle.italic)
        : const TextStyle(fontStyle: FontStyle.italic);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _revealed = true),
      child: Text(
        placeholder,
        style: placeholderStyle,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        overflow: widget.overflow,
      ),
    );
  }
}
