import 'package:flutter/material.dart';

class RecyclerView extends StatelessWidget {
  final Widget? header;
  final List<Widget> children;

  const RecyclerView({super.key, this.header, required this.children});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: children.length + (header == null ? 0 : 1),
        itemBuilder: (_, i) {
          return (i == 0 && header != null)
              ? header
              : children[i - (header == null ? 0 : 1)];
        });
  }
}
