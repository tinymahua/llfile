import 'package:flutter/material.dart';


typedef LlTreeNodeTapCallback<D> = void Function(D data);


class LlTreeNode<D> {
  LlTreeNode({
    this.key,
    this.data,
    required this.titleWidget,
    required this.children,
    this.onTreeNodeTap,
  });

  final Key? key;
  final D? data;
  final Widget titleWidget;
  final List<LlTreeNode<D>> children;
  final LlTreeNodeTapCallback<D>? onTreeNodeTap;
}