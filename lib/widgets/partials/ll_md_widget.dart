import 'dart:convert';
import 'dart:io';

import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:flutter_highlight/themes/kimbie.light.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:llfile/models/markdown_model.dart';
import 'package:llfile/utils/db.dart';
import 'package:llfile/widgets/common/buttons.dart';
import 'package:llfile/widgets/common/keep_alive_wrapper.dart';
import 'package:llfile/widgets/common/ll_tree_widget.dart';
import 'package:llfile/widgets/common/ll_window_widget.dart';
import 'package:highlight/languages/markdown.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LlMdWidget extends StatefulWidget {
  const LlMdWidget({super.key});

  @override
  State<LlMdWidget> createState() => _LlMdWidgetState();
}

const String edit = "Edit";
const String preview = "Preview";

class _LlMdWidgetState extends State<LlMdWidget> {
  Set<String> selected = {preview};

  PageController _pageController = PageController();
  String _mdContent = "";

  final _codeController = CodeController(
    text: "",
    language: markdown,
  );

  MdConfigDb _mdConfigDb = Get.find<MdConfigDb>();
  MdConfig? _mdConfig;

  List<MdCollect> _mdData = [];
  TreeController<LlTreeNode<MdCollect>>? _mdTreeController;
  int _treeHoverIndex = -1;
  @override
  void initState() {
    super.initState();
    setupEvents();
  }

  setupEvents() async {
    var loadedMdConfig = await _mdConfigDb.read<MdConfig>();
    setState(() {
      _mdConfig = loadedMdConfig;
    });

    await reloadMdData(_mdConfig!.mdDataFsPath);
  }

  reloadMdData(String dataFsPath) async {
    print("dataFsPath: ${dataFsPath}");
    var data = await File(dataFsPath).readAsString();
    var dataMap = jsonDecode(data);
    List<MdCollect> mdData = (dataMap["collections"] as List<dynamic>)
        .map((e) => MdCollect.fromJson(e))
        .toList();
    setState(() {
      _mdData = mdData;
    });

    List<LlTreeNode<MdCollect>> refreshedTreeNodes = await generateTreeNodes();
    setState(() {
      _mdTreeController = TreeController(
          roots: refreshedTreeNodes,
          childrenProvider: (LlTreeNode<MdCollect> node) => node.children);
    });
  }

  Future<List<LlTreeNode<MdCollect>>> generateTreeNodes() async {
    var mdTreeNodes = <LlTreeNode<MdCollect>>[];
    for (var mdCollect in _mdData) {
      var mdTreeNode = await generateTreeNode(mdCollect);
      mdTreeNodes.add(mdTreeNode);
    }
    return mdTreeNodes;
  }

  Future<LlTreeNode<MdCollect>> generateTreeNode(MdCollect mdc) async {
    List<LlTreeNode<MdCollect>> treeNodeChildren = [];
    if (mdc.subCollects.isNotEmpty) {
      for (var subCollect in mdc.subCollects) {
        var subTreeNode = await generateTreeNode(subCollect);
        treeNodeChildren.add(subTreeNode);
      }
    }

    var llTreeNode = LlTreeNode<MdCollect>(
        titleWidget: Text("${mdc.name}"), children: treeNodeChildren);
    return llTreeNode;
  }

  Widget _buildSidebar() {
    return Container(
      width: 200,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                MouseRegion(
                  child: TapOrDoubleTapButton(
                      onTap: () {},
                      child: Icon(
                        Icons.search,
                        size: 16,
                      )),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Expanded(
              child: Container(
            child: _mdTreeController != null && _mdData.isNotEmpty
                ? TreeView(
                    treeController: _mdTreeController!,
                    nodeBuilder: (BuildContext context,
                        TreeEntry<LlTreeNode<MdCollect>> entry) {
                      // return Container(
                      //   child: entry.node.titleWidget,
                      // );
                      Widget icon = Container();
                      if (entry.node.children.isNotEmpty) {
                        if (entry.isExpanded) {
                          icon = Icon(
                            Icons.keyboard_arrow_down,
                            size: 15,
                          );
                        } else {
                          icon = Icon(
                            Icons.keyboard_arrow_right,
                            size: 15,
                          );
                        }
                      }

                      if (entry.level == 0) {
                        icon = Icon(
                          Icons.home,
                          size: 15,
                        );
                      }

                      return MouseRegion(
                        onHover: (event) {
                          setState(() {
                            _treeHoverIndex = entry.index;
                          });
                        },
                        onExit: (event){
                          setState(() {
                            _treeHoverIndex = -1;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: _treeHoverIndex == entry.index
                                ? Theme.of(context).dividerTheme.color
                                : Colors.transparent,
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: TreeIndentation(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Container(
                                    width: 16,
                                    color: Colors.transparent,
                                    child: icon,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  entry.node.titleWidget,
                                ],
                              ),
                              entry: entry,
                              guide: const IndentGuide.connectingLines(
                                  indent: 16, color: Colors.transparent),
                            ),
                          ),
                        ),
                      );
                    })
                : Container(
                    child: Column(
                      children: [
                        Text(
                            "${AppLocalizations.of(context)!.markdownDataEmptyText}"),
                        SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              await _mdConfigDb
                                  .createMdCollection("Markdown Home", [], []);
                              reloadMdData(_mdConfig!.mdDataFsPath);
                            },
                            child: Text(
                                "${AppLocalizations.of(context)!.markdownNewCollectButtonLabel}")),
                      ],
                    ),
                  ),
          ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LlWindowWidget(
      isHome: false,
      sidebar: _buildSidebar(),
      extra: null,
      extraSize: 0,
      extraSizeMin: 0,
      extraSizeMax: 0,
      content: Column(
        children: [
          Expanded(
              child: PageView(
            controller: _pageController,
            children: [
              KeepAliveWrapper(child: Markdown(data: _mdContent)),
              KeepAliveWrapper(
                  child: CodeTheme(
                data: CodeThemeData(styles: kimbieLightTheme),
                child: Column(
                  children: [
                    // TextField(minLines: 10, maxLines: 16,),
                    Expanded(
                      child: SingleChildScrollView(
                        child: CodeField(
                          lineNumbers: false,
                          minLines: 200,
                          wrap: true,
                          controller: _codeController,
                          onChanged: (text) {
                            print("text: ${text}");
                            setState(() {
                              // _codeController.text = text;
                              _mdContent = text;
                            });
                          },
                        ),
                      ),
                    )
                  ],
                ),
              )),
            ],
          )),
          Row(
            children: [
              SegmentedButton(
                  onSelectionChanged: (value) {
                    setState(() {
                      selected = value;
                    });
                    if (value.contains(preview)) {
                      _pageController.jumpToPage(0);
                    } else {
                      _pageController.jumpToPage(1);
                    }
                  },
                  segments: [
                    ButtonSegment(
                        value: preview,
                        label: Text(
                            "${AppLocalizations.of(context)!.markdownPreviewLabel}")),
                    ButtonSegment(
                        value: edit,
                        label: Text(
                            "${AppLocalizations.of(context)!.markdownEditLabel}")),
                  ],
                  selected: selected)
            ],
          )
        ],
      ),
    );
  }
}
