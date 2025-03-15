import 'dart:convert';
import 'dart:io';

import 'package:code_text_field/code_text_field.dart';
import 'package:contextmenu/contextmenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:flutter_highlight/themes/kimbie.light.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:highlight/languages/awk.dart';
import 'package:llfile/models/markdown_model.dart';
import 'package:llfile/utils/db.dart';
import 'package:llfile/widgets/common/buttons.dart';
import 'package:llfile/widgets/common/context_menu_widget.dart';
import 'package:llfile/widgets/common/keep_alive_wrapper.dart';
import 'package:llfile/widgets/common/ll_tree_widget.dart';
import 'package:llfile/widgets/common/ll_window_widget.dart';
import 'package:highlight/languages/markdown.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

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

  List<MdObject> _mdData = [];
  List<LlTreeNode<MdObject>> _refreshedTreeNodes = [];
  TreeController<LlTreeNode<MdObject>>? _mdTreeController;
  int _treeHoverIndex = -1;

  final TextEditingController _newMdObjectTextController = TextEditingController();
  final TextEditingController _newMdObjectPathController = TextEditingController();

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

  refreshDb()async{
    var refreshedMdConfig = await _mdConfigDb.read<MdConfig>();
    setState(() {
      _mdConfig = refreshedMdConfig;
    });
  }

  reloadMdData(String dataFsPath) async {
    print("dataFsPath: ${dataFsPath}");
    var data = await File(dataFsPath).readAsString();
    var dataMap = jsonDecode(data);
    List<MdObject> mdObjects = (dataMap[MdConfigDb.mdRootKey] as List<dynamic>)
        .map((e) => MdObject.fromJson(e))
        .toList();
    setState(() {
      _mdData = mdObjects;
    });

    List<LlTreeNode<MdObject>> refreshedTreeNodes = await generateTreeNodes();
    setState(() {
      _refreshedTreeNodes = refreshedTreeNodes;
    });
    setState(() {
      _mdTreeController = TreeController(
          roots: _refreshedTreeNodes,
          // defaultExpansionState: true,
          childrenProvider: (LlTreeNode<MdObject> node) => node.children);
    });
    await defaultExpandTreeNodes();
  }

  defaultExpandTreeNodes()async{
    for (var treeNode in _refreshedTreeNodes){
      await defaultExpandTreeNode(treeNode);
    }
  }

  defaultExpandTreeNode(LlTreeNode<MdObject> node)async{
    print("defaultExpandTreeNode: ${node.data!.id} ${node.data!.objectName} : ${_mdTreeController!.getExpansionState(node)} : ${_mdConfig!.expandedObjectIds.contains(node.data!.id)}");
    if (!_mdTreeController!.getExpansionState(node)){
      if (_mdConfig!.expandedObjectIds.contains(node.data!.id)){
        _mdTreeController!.expand(node);
      }
    }
    for (var i = 0; i < node.children.length; i++) {
      var childNode = node.children[i];
      await defaultExpandTreeNode(childNode);
    }
  }

  Future<List<LlTreeNode<MdObject>>> generateTreeNodes() async {
    List<MdObject> rootMdObjects =
        _mdData.where((element) => element.parentObjectId.isEmpty).toList();
    var mdTreeNodes = <LlTreeNode<MdObject>>[];
    for (var i = 0; i < rootMdObjects.length; i++) {
      var mdo = rootMdObjects[i];
      var mdTreeNode = await generateTreeNode(mdo);
      mdTreeNodes.add(mdTreeNode);
    }
    return mdTreeNodes;
  }

  Future<LlTreeNode<MdObject>> generateTreeNode(MdObject mdo) async {
    List<LlTreeNode<MdObject>> treeNodeChildren = [];
    String mdObjectName = "";
    if (mdo.type == MdObjectType.collection) {
        List<MdObject> subMdObjects = _mdData
            .where((element) => element.parentObjectId == mdo.id)
            .toList();
        if (subMdObjects.isNotEmpty) {
          for (var j = 0; j < subMdObjects.length; j++) {
            var subMdObject = subMdObjects[j];
            var subTreeNode = await generateTreeNode(subMdObject);
            treeNodeChildren.add(subTreeNode);
          }
        }
      // }
      mdObjectName = MdCollection.fromJson(mdo.data).name;
    } else {
      mdObjectName = MdDocument.fromJson(mdo.data).title;
    }
    // print("${mdo.data} treeNodeChildren: ${treeNodeChildren}");
    var llTreeNode = LlTreeNode<MdObject>(
      key: Key(mdo.id),
        titleWidget: Text("${mdObjectName}"),
        data: mdo,
        children: treeNodeChildren);
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
                        TreeEntry<LlTreeNode<MdObject>> entry) {
                      Widget icon = Container();
                      if (entry.node.data!.type == MdObjectType.collection) {
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
                      }else{
                        icon = Icon(Icons.data_array, size: 15,);
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
                        onExit: (event) {
                          setState(() {
                            _treeHoverIndex = -1;
                          });
                        },
                        child: GestureDetector(
                          onTap: () {
                            _mdTreeController!.toggleExpansion(entry.node);

                            print("state #${entry.node.data!.id}: ${_mdTreeController!.getExpansionState(entry.node)}");
                            if (_mdTreeController!.getExpansionState(entry.node)){
                              _mdConfigDb.expandMdObject(entry.node.data!.id);
                              refreshDb();
                            }else{
                              _mdConfigDb.collapseMdObject(entry.node.data!.id);
                              refreshDb();
                            }
                            if (entry.node.onTreeNodeTap != null && entry.node.data != null){
                              entry.node.onTreeNodeTap!(entry.node.data!);
                            }
                          },
                          onSecondaryTapDown: (details) {
                            setState(() {
                              _treeHoverIndex = entry.index;
                            });
                            openMdTreeNodeContextMenu(
                                context, details, entry.node.data!, entry.node);
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
                                entry: entry,
                                guide: const IndentGuide.connectingLines(
                                    indent: 16, color: Colors.transparent),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Container(
                                      width: 16,
                                      color: Colors.transparent,
                                      child: icon,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    entry.node.titleWidget,
                                  ],
                                ),
                              ),
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
                              await _mdConfigDb.createMdObject(
                                  "",
                                  MdObjectType.collection,
                                  MdCollection(
                                          objectType: MdObjectType.collection
                                              .toString(),
                                          id: const Uuid().v4(),
                                          name: "Markdown Home",
                                          documents: [],
                                          parentObjectId: "")
                                      .toJson());
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

  openMdTreeNodeContextMenu(
      BuildContext context, TapDownDetails details, MdObject mdObject, LlTreeNode<MdObject> currentNode) {
    showContextMenu(details.globalPosition, context, (BuildContext context) {
      return getMdTreeNodeContextMenuViews(mdObject, currentNode);
    }, 0.0, 240.0);
  }

  List<Widget> getMdTreeNodeContextMenuViews(MdObject mdObject, LlTreeNode<MdObject> currentNode) {
    List<ContextMenuView> contextMenuViews = [];
    contextMenuViews = [
      ContextMenuView(
        menuSections: [
          [
            ContextMenuItem(
                onTap: () async {
                  Navigator.of(context).pop();
                  await onNewMdCollection(mdObject, currentNode);
                  reloadMdData(_mdConfig!.mdDataFsPath);
                },
                icon: Container(),
                title: Text(AppLocalizations.of(context)!
                    .markdownNewSubCollectButtonLabel)),
            ContextMenuItem(
                onTap: () async {
                  Navigator.of(context).pop();
                  await onNewMdDocument(mdObject, currentNode);
                  reloadMdData(_mdConfig!.mdDataFsPath);
                },
                icon: Container(),
                title: Text(AppLocalizations.of(context)!
                    .markdownNewDocumentButtonLabel)),
          ]
        ],
        divider: Divider(
          height: 1,
        ),
      )
    ];
    return contextMenuViews;
  }

  onNewMdCollection(MdObject mdObject, LlTreeNode<MdObject> currentNode) async {
    var dialogTitle =
        AppLocalizations.of(context)!.markdownNewSubCollectButtonLabel;

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(dialogTitle),
            content: Container(
              child: TextField(
                controller: _newMdObjectTextController,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.cancelLabel)),
              TextButton(
                  onPressed: () async {
                    String newMdObjectName =
                        _newMdObjectTextController.text.trim();
                    if (newMdObjectName.isNotEmpty) {
                      if (!newMdObjectNameValid(newMdObjectName)) {
                        return;
                      }
                      await _mdConfigDb.createMdObject(
                          mdObject.id,
                          MdObjectType.collection,
                          MdCollection(
                                  objectType:
                                      MdObjectType.collection.toString(),
                                  id: const Uuid().v4(),
                                  name: newMdObjectName,
                                  documents: [],
                                  parentObjectId: mdObject.id)
                              .toJson());
                    }
                    await reloadMdData(_mdConfig!.mdDataFsPath);
                    await _mdConfigDb.expandMdObject(currentNode.data!.id);
                    // await defaultExpandTreeNodes();
                    _mdTreeController!.expand(currentNode);
                    _newMdObjectTextController.clear();
                    _newMdObjectPathController.clear();
                    Navigator.of(context).pop();

                    // eventBus.fire(PathChangeEvent(path: _currentFsPath));
                  },
                  child: Text(AppLocalizations.of(context)!.okLabel))
            ],
          );
        });
  }

  onNewMdDocument(MdObject mdObject, LlTreeNode<MdObject> currentNode) async {
    var dialogTitle =
        AppLocalizations.of(context)!.markdownNewDocumentButtonLabel;

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(dialogTitle),
            content: Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _newMdObjectTextController,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _newMdObjectPathController,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.cancelLabel)),
              TextButton(
                  onPressed: () async {
                    String newMdObjectName =
                        _newMdObjectTextController.text.trim();
                    String newMdObjectPath =
                        _newMdObjectPathController.text.trim();
                    if (newMdObjectName.isNotEmpty) {
                      if (!newMdObjectNameValid(newMdObjectName)) {
                        return;
                      }
                      if (!newMdObjectPathValid(newMdObjectPath)) {
                        return;
                      }
                      await _mdConfigDb.createMdObject(
                          mdObject.id,
                          MdObjectType.document,
                          MdDocument(
                                  objectType: MdObjectType.document.toString(),
                                  id: const Uuid().v4(),
                                  title: newMdObjectName,
                                  fsPath: newMdObjectPath,
                                  parentObjectId: mdObject.id)
                              .toJson());
                    }
                    await reloadMdData(_mdConfig!.mdDataFsPath);
                    await _mdConfigDb.expandMdObject(currentNode.data!.id);
                    // await defaultExpandTreeNodes();
                    _mdTreeController!.expand(currentNode);
                    _newMdObjectTextController.clear();
                    _newMdObjectPathController.clear();
                    Navigator.of(context).pop();

                  },
                  child: Text(AppLocalizations.of(context)!.okLabel))
            ],
          );
        });
  }

  newMdObjectNameValid(String name) {
    if (name.isEmpty) {
      return false;
    }
    if (name.contains(RegExp(r'[/\\:*?"<>|]'))) {
      return false;
    }
    return true;
  }

  newMdObjectPathValid(String path) {
    if (path.isEmpty) {
      return false;
    }
    if (path.contains(RegExp(r'[/\\:*?"<>|]'))) {
      return false;
    }
    return true;
  }
}
