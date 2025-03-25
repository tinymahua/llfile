import 'dart:convert';
import 'dart:io';

import 'package:code_text_field/code_text_field.dart';
import 'package:contextmenu/contextmenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/kimbie.light.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:llfile/models/markdown_model.dart';
import 'package:llfile/utils/db.dart';
import 'package:llfile/widgets/common/buttons.dart';
import 'package:llfile/widgets/common/context_menu_widget.dart';
import 'package:llfile/widgets/common/keep_alive_wrapper.dart';
import 'package:llfile/widgets/common/ll_window_widget.dart';
import 'package:highlight/languages/markdown.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import 'package:animated_tree_view/animated_tree_view.dart';


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

  List<MdObject> _mdObjects = [];
  String _treeHoveredMdObjectId = "-------";

  TreeViewController<MdObject, IndexedTreeNode<MdObject>>? _mdNavTreeController;
  IndexedTreeNode<MdObject> _mdNavTree = IndexedTreeNode.root(data: MdObject(
      id: "", type: MdObjectType.collection, data: {}, parentObjectId: ""));


  final TextEditingController _newMdObjectTextController = TextEditingController();
  FocusNode _newMdObjectTextFocus = FocusNode();
  final TextEditingController _newMdObjectLocationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setupEvents();
  }

  setupEvents() async {
    var loadedMdConfig = await _mdConfigDb.read<MdConfig>();
    var mdDocsRootPath = loadedMdConfig.mdDocsRootPath;
    setState(() {
      _mdConfig = loadedMdConfig;
    });
    setState(() {
      _newMdObjectLocationController.text = mdDocsRootPath;
    });

    await loadMdObjects(_mdConfig!.mdDataFsPath);
  }

  loadMdObjects(String dataFsPath) async {
    print("dataFsPath: ${dataFsPath}");
    var data = await File(dataFsPath).readAsString();
    var dataMap = jsonDecode(data);
    List<MdObject> mdObjects = (dataMap[MdConfigDb.mdRootKey] as List<dynamic>)
        .map((e) => MdObject.fromJson(e))
        .toList();
    setState(() {
      _mdObjects = mdObjects;
    });

    IndexedTreeNode<MdObject> loadedMdNavTree = await generateNavTree(null, _mdNavTree);
    setState(() {
      _mdNavTree = loadedMdNavTree;
    });

  }


  Future<IndexedTreeNode<MdObject>> generateNavTree(MdObject? parentMdObject, IndexedTreeNode<MdObject> parentTreeNode) async {
    List<MdObject> rootMdObjects =
    _mdObjects.where(
            (element) => parentMdObject == null ? element.parentObjectId.isEmpty: element.parentObjectId == parentMdObject.id).toList();

    for (var i=0; i<rootMdObjects.length; i++){
      MdObject currentMdObject = rootMdObjects[i];
      IndexedTreeNode<MdObject> currentTreeNode = IndexedTreeNode(key: currentMdObject.id, data: currentMdObject);
      parentTreeNode.add(currentTreeNode);
      await generateNavTree(currentMdObject, currentTreeNode);
    }
    return parentTreeNode;
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
                // color: Colors.teal,
                child: TreeView.indexed(
                  onTreeReady: (controller){
                    _mdNavTreeController = controller;
                  },
                    expansionIndicatorBuilder: (context,  node){
                      var mdObject = node.data! as MdObject;
                        return mdObject.type == MdObjectType.collection ? ChevronIndicator.rightDown(
                          alignment: Alignment.centerLeft,
                          tree: node,
                          color: Colors.blue[700],
                          // padding: const EdgeInsets.only(right: 20),
                        ): NoExpansionIndicator(tree: node);
                    },
                    builder: (context, node){
                      var title = node.level == 0 ? "Markdown Home" : node.data!.objectName;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: _treeHoveredMdObjectId == node.data!.id
                                  ? Theme.of(context).dividerTheme.color
                                  : Colors.transparent,
                            ),
                            child: MouseRegion(
                                onHover: (event) {
                                  setState(() {
                                    _treeHoveredMdObjectId = node.data!.id;
                                  });
                                },
                                onExit: (event) {
                                  setState(() {
                                    _treeHoveredMdObjectId = "---------";
                                  });
                                },
                              child: Container(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: GestureDetector(
                                      onSecondaryTapDown: (details){
                                        openMdTreeNodeContextMenu(context, details, node.data!, node);
                                      },
                                      child: Text(title),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )],
                      );
                    }, tree: _mdNavTree) ,
              )
          )
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
      BuildContext context, TapDownDetails details, MdObject mdObject, IndexedTreeNode<MdObject> currentNode) {
    showContextMenu(details.globalPosition, context, (BuildContext context) {
      return getMdTreeNodeContextMenuViews(context, mdObject, currentNode);
    }, 0.0, 240.0);
  }

  List<Widget> getMdTreeNodeContextMenuViews(BuildContext context, MdObject mdObject, IndexedTreeNode<MdObject> currentNode) {
    List<ContextMenuView> contextMenuViews = [];
    contextMenuViews = [
      ContextMenuView(
        menuSections: [
          [
            ContextMenuItem(
                onTap: () async {
                  Navigator.of(context).pop();
                  await onNewMdCollection(context, currentNode);

                  // reloadMdData(_mdConfig!.mdDataFsPath);
                },
                icon: Container(),
                title: Text(AppLocalizations.of(context)!
                    .markdownNewSubCollectButtonLabel)),
            ContextMenuItem(
                onTap: () async {
                  Navigator.of(context).pop();
                  await onNewMdDocument(context, currentNode);
                  // reloadMdData(_mdConfig!.mdDataFsPath);
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

  onNewMdCollection(BuildContext context, IndexedTreeNode<MdObject> currentNode) async {
    var dialogTitle =
        AppLocalizations.of(context)!.markdownNewSubCollectButtonLabel;

    var currentMdObject = currentNode.data!;
    _newMdObjectTextFocus.requestFocus();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            width: 960,
            child: AlertDialog(
              title: Text(dialogTitle),
              content: Container(
                child: TextField(
                  autofocus: true,
                  // focusNode: _newMdObjectTextFocus,
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
                        var newMdObject = await _mdConfigDb.createMdObject(
                            currentMdObject.id,
                            MdObjectType.collection,
                            MdCollection(
                                objectType:
                                MdObjectType.collection.toString(),
                                id: const Uuid().v4(),
                                name: newMdObjectName,
                                documents: [],
                                parentObjectId: currentMdObject.id)
                                .toJson());

                        currentNode.add(IndexedTreeNode(key: "${newMdObject.id}", data: newMdObject, parent: currentNode));
                        if (!currentNode.isExpanded){
                          _mdNavTreeController!.expandAllChildren(currentNode);
                        }
                        setState(() {
                          _newMdObjectTextController.clear();
                        });
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(AppLocalizations.of(context)!.okLabel))
              ],
            ),
          );
        });
  }

  onNewMdDocument(BuildContext context, IndexedTreeNode<MdObject> currentNode) async {
    var dialogTitle =
        AppLocalizations.of(context)!.markdownNewDocumentButtonLabel;

    var currentMdObject = currentNode.data!;
    _newMdObjectTextFocus.requestFocus();
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
                      SizedBox(width: 60, child: Text("文档位置"),),
                      Expanded(
                        child: TextField(
                          readOnly: true,
                          controller: _newMdObjectLocationController,
                        ),
                      ),
                      Container(width: 48, child: IconButton(onPressed: (){}, icon:Text("···")),)
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: 60, child: Text("文档名称"),),
                      Expanded(
                        child: TextField(
                          focusNode: _newMdObjectTextFocus,
                          controller: _newMdObjectTextController,
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

                    var parts = newMdObjectName.split(".");
                    String newMdObjectLocation =
                    _newMdObjectLocationController.text.trim();

                    String newMdObjectPath = "";
                    if (parts.last.toLowerCase() == 'md'){
                      newMdObjectPath = join(newMdObjectLocation, newMdObjectName);
                    }else{
                      newMdObjectPath = join(newMdObjectLocation, "${newMdObjectName}.md");
                    }

                    if (newMdObjectName.isNotEmpty) {
                      if (!newMdObjectNameValid(newMdObjectName)) {
                        print("New object name invalid");
                        return;
                      }
                      if (!await newMdObjectPathValid(newMdObjectLocation)) {
                        print("New object path invalid");
                        return;
                      }
                      var newMdObject = await _mdConfigDb.createMdObject(
                          currentMdObject.id,
                          MdObjectType.document,
                          MdDocument(
                              objectType: MdObjectType.document.toString(),
                              id: const Uuid().v4(),
                              title: newMdObjectName,
                              fsPath: newMdObjectPath,
                              parentObjectId: currentMdObject.id)
                              .toJson());

                      currentNode.add(IndexedTreeNode(key: "${newMdObject.id}", data: newMdObject, parent: currentNode));
                      if (!currentNode.isExpanded){
                        _mdNavTreeController!.expandAllChildren(currentNode);
                      }
                      setState(() {
                        _newMdObjectTextController.clear();
                      });
                      Navigator.of(context).pop();
                    }

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

  newMdObjectPathValid(String path) async{
    if (path.isEmpty) {
      return false;
    }

    return true;
  }


}
