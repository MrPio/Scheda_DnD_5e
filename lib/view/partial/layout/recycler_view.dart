import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/constant/measures.dart';

class RecyclerView extends StatelessWidget {
  final Widget? header;
  final List<Widget> children;
  final EdgeInsets padding;

  const RecyclerView(
      {super.key,
      this.header,
      required this.children,
      this.padding = const EdgeInsets.only(bottom: Measures.vMarginBig * 3)});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: padding,
        itemCount: children.length + (header == null ? 0 : 1),
        itemBuilder: (_, i) {
          return (i == 0 && header != null) ? header : children[i - (header == null ? 0 : 1)];
        });
  }
}
