import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';

class LlNavTreeNode {
  const LlNavTreeNode({
    this.key,
    required this.titleWidget,
    this.children = const <LlNavTreeNode>[],
    this.onTap,
  });

  final Key? key;
  final Widget titleWidget;
  final List<LlNavTreeNode> children;
  final GestureTapCallback? onTap;
}


class LlSettingsSideNavWidget extends StatefulWidget {
  const LlSettingsSideNavWidget({super.key, required this.navItems});

  final List<LlNavTreeNode> navItems;

  @override
  State<LlSettingsSideNavWidget> createState() => _LlSettingsSideNavWidgetState();
}

class _LlSettingsSideNavWidgetState extends State<LlSettingsSideNavWidget> {
  TreeController<LlNavTreeNode>? _treeController;
  Key? _selectedItemKey;

  @override
  void initState() {
    super.initState();
    _treeController = TreeController<LlNavTreeNode>(
      roots: widget.navItems,
      childrenProvider: (LlNavTreeNode node) => node.children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _treeController != null
        ? Container(
            child: TreeView(
                treeController: _treeController!,
                nodeBuilder:
                    (BuildContext context, TreeEntry<LlNavTreeNode> entry) {
                  FontWeight textWeight = FontWeight.w200;
                  if (entry.level == 0){
                    textWeight = FontWeight.w700;
                  }else if (entry.level == 1){
                    textWeight = FontWeight.w500;
                  }else if (entry.level == 2){
                    textWeight = FontWeight.w300;
                  }

                  Widget icon = Container();
                  if (entry.node.children.isNotEmpty){
                    if (entry.isExpanded){
                      icon = Icon(Icons.keyboard_arrow_down, size: 15,);
                    }else{
                      icon = Icon(Icons.keyboard_arrow_right, size: 15,);
                    }
                  }
                  return Container(
                    margin: EdgeInsets.only(top: 2, bottom: 2),
                    decoration: BoxDecoration(
                      color: entry.node.key != null && entry.node.key == _selectedItemKey ? Colors.grey : Colors.transparent,
                    ),
                    child: GestureDetector(
                      key: ValueKey(entry.node),
                      onTap: () {
                        _treeController!.toggleExpansion(entry.node);
                        setState(() {
                          _selectedItemKey = entry.node.key;
                        });
                        entry.node.onTap?.call();
                      },
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: TreeIndentation(
                          entry: entry,
                          guide: const IndentGuide.connectingLines(
                              indent: 16, color: Colors.transparent),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 16,
                                color: Colors.transparent,
                                child: icon,
                              ),
                              entry.node.titleWidget,
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          )
        : Container();
  }
}

