import 'dart:convert';
import 'dart:io';

import 'package:contextmenu/contextmenu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/events/md_events.dart';
import 'package:llfile/models/markdown_model.dart';
import 'package:llfile/utils/db.dart';
import 'package:fluent_ui/fluent_ui.dart' as fui;
import 'package:llfile/widgets/common/buttons.dart';
import 'package:llfile/widgets/common/context_menu_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

///
/// Markdown Nav Tree
///
class LlMdNavTreeWidget extends StatefulWidget {
  const LlMdNavTreeWidget({super.key});

  @override
  State<LlMdNavTreeWidget> createState() => _LlMdNavTreeWidgetState();
}

class _LlMdNavTreeWidgetState extends State<LlMdNavTreeWidget> {
  MdConfigDb _mdConfigDb = Get.find<MdConfigDb>();
  MdConfig? _mdConfig;

  List<MdObject> _mdObjects = [];

  final TextEditingController _newMdObjectTextController =
  TextEditingController();
  FocusNode _newMdObjectTextFocus = FocusNode();
  final TextEditingController _newMdObjectLocationController =
  TextEditingController();

  ValueNotifier<int> _mdTreeItemsNotifier = ValueNotifier<int>(0);
  List<fui.TreeViewItem> _mdNavTreeItems = [];

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
    _mdTreeItemsNotifier.value++;
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

    List<fui.TreeViewItem> loadedMdNavTreeItems =
    await generateTreeViewItems(null);
    setState(() {
      _mdNavTreeItems = loadedMdNavTreeItems;
    });
  }

  Future<List<fui.TreeViewItem>> generateTreeViewItems(
      MdObject? parentMdObject) async {
    List<fui.TreeViewItem> loadedTreeItems = [];

    List<MdObject> rootMdObjects = _mdObjects
        .where((element) => parentMdObject == null
        ? element.parentObjectId.isEmpty
        : element.parentObjectId == parentMdObject.id)
        .toList();

    for (var i = 0; i < rootMdObjects.length; i++) {
      MdObject currentMdObject = rootMdObjects[i];
      var currentMdTreeItem = await generateTreeViewItem(currentMdObject);
      loadedTreeItems.add(currentMdTreeItem);
    }
    return loadedTreeItems;
  }

  Future<fui.TreeViewItem> generateTreeViewItem(MdObject mdObject) async {
    List<fui.TreeViewItem> myChildren = [];

    List<MdObject> mySubObjects = _mdObjects
        .where((element) => element.parentObjectId == mdObject.id)
        .toList();
    for (var j = 0; j < mySubObjects.length; j++) {
      myChildren.add(await generateTreeViewItem(mySubObjects[j]));
    }

    double iconSize = 16;
    Widget itemIcon = mdObject.type == MdObjectType.collection
        ? Icon(
      Icons.folder_outlined,
      size: iconSize,
    )
        : Icon(
      Icons.code_outlined,
      size: iconSize,
    );
    return fui.TreeViewItem(
      content: Row(children: [
        itemIcon,
        SizedBox(
          width: 5,
        ),
        Text("${mdObject.objectName}")
      ]),
      value: mdObject,
      children: myChildren,
    );
  }

  @override
  Widget build(BuildContext context) {
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
          SizedBox(
            height: 10,
          ),
          _mdNavTreeItems.isNotEmpty
              ? Expanded(
              child: fui.FluentTheme(
                data: fui.FluentThemeData(),
                child: ValueListenableBuilder<int>(
                  valueListenable: _mdTreeItemsNotifier,
                  builder: (context, value, _) {
                    print("value: ${value}");
                    print("_mdNavTreeItems: ${_mdNavTreeItems}");
                    return fui.TreeView(
                      key: Key("${value}"),
                      selectionMode: fui.TreeViewSelectionMode.single,
                      shrinkWrap: true,
                      items: _mdNavTreeItems,
                      // onItemInvoked: (item) async => debugPrint('onItemInvoked: \$item'),
                      onItemInvoked: (item, reason) async {
                        print("item click");
                        tapMdTreeNode(context, item);
                      },
                      onItemExpandToggle: (item, expanded) async {
                        print("item expand toggle");
                        tapMdTreeNode(context, item);
                      },
                      onSelectionChanged: (selectedItems) async => debugPrint(
                          'onSelectionChanged: \${selectedItems.map((i) => i.value)}'),
                      onSecondaryTap: (item, details) async {
                        debugPrint(
                            'onSecondaryTap $item at ${details.globalPosition}');
                        openMdTreeNodeContextMenu(
                            context, details, item.value, item);
                      },
                    );
                  },
                ),
              ))
              : Container(
                height: 100,
                child: Center(
                  child: ElevatedButton(onPressed: ()async{
                    // await onNewMdCollection(context, currentItem);
                    var newMdObject = await _mdConfigDb.createMdObject(
                        "",
                        MdObjectType.collection,
                        MdCollection(
                            objectType:
                            MdObjectType.collection.toString(),
                            id: const Uuid().v4(),
                            name: "Root",
                            documents: [],
                            parentObjectId: "")
                            .toJson());
                    await loadMdObjects(_mdConfig!.mdDataFsPath);

                  }, child: Text(AppLocalizations.of(context)!.markdownNewCollectButtonLabel)),
                ),
              ),
        ],
      ),
    );
  }

  tapMdTreeNode(BuildContext context, fui.TreeViewItem item) async {
    MdObject mdObject = item.value as MdObject;
    if (mdObject.type == MdObjectType.collection) {
      item.expanded = !item.expanded;
      _mdTreeItemsNotifier.value++;
    } else {
      // setState(() {
      //   _selectedMdObjectId = mdObject.id;
      // });
      item.selected = true;
      _mdTreeItemsNotifier.value++;
      eventBus
          .fire(OpenMdObjectEvent(mdObject: mdObject));
    }
  }

  openMdTreeNodeContextMenu(BuildContext context, TapDownDetails details,
      MdObject mdObject, fui.TreeViewItem currentItem) {
    showContextMenu(details.globalPosition, context, (BuildContext context) {
      return getMdTreeNodeContextMenuViews(context, mdObject, currentItem);
    }, 0.0, 240.0);
  }

  List<Widget> getMdTreeNodeContextMenuViews(
      BuildContext context, MdObject mdObject, fui.TreeViewItem currentItem) {
    List<ContextMenuView> contextMenuViews = [];
    contextMenuViews = [
      ContextMenuView(
        menuSections: [
          [
            ContextMenuItem(
                onTap: () async {
                  Navigator.of(context).pop();
                  await onNewMdCollection(context, currentItem);
                  _newMdObjectTextController.clear();
                },
                icon: Container(),
                title: Text(AppLocalizations.of(context)!
                    .markdownNewSubCollectButtonLabel)),
            ContextMenuItem(
                onTap: () async {
                  Navigator.of(context).pop();
                  await onNewMdDocument(context, currentItem);
                  _newMdObjectTextController.clear();
                  // reloadMdData(_mdConfig!.mdDataFsPath);
                },
                icon: Container(),
                title: Text(AppLocalizations.of(context)!
                    .markdownNewDocumentButtonLabel)),
          ]
        ],
      )
    ];
    return contextMenuViews;
  }

  onNewMdCollection(BuildContext context, fui.TreeViewItem currentItem) async {
    var dialogTitle =
        AppLocalizations.of(context)!.markdownNewSubCollectButtonLabel;

    var currentMdObject = currentItem.value as MdObject;
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

                        currentItem.children.add(fui.TreeViewItem(
                            content: Text("${newMdObject.objectName}"),
                            value: newMdObject,
                            children: []));
                        if (!currentItem.expanded) {
                          currentItem.expanded = true;
                        }
                        _mdTreeItemsNotifier.value++;

                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(AppLocalizations.of(context)!.okLabel))
              ],
            ),
          );
        });
  }

  onNewMdDocument(BuildContext context, fui.TreeViewItem currentItem) async {
    var dialogTitle =
        AppLocalizations.of(context)!.markdownNewDocumentButtonLabel;

    var currentMdObject = currentItem.value as MdObject;
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
                      SizedBox(
                        width: 60,
                        child: Text("文档位置"),
                      ),
                      Expanded(
                        child: TextField(
                          readOnly: true,
                          controller: _newMdObjectLocationController,
                        ),
                      ),
                      Container(
                        width: 48,
                        child: IconButton(onPressed: () {}, icon: Text("···")),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 60,
                        child: Text("文档名称"),
                      ),
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
                    if (parts.last.toLowerCase() == 'md') {
                      newMdObjectPath =
                          join(newMdObjectLocation, newMdObjectName);
                    } else {
                      newMdObjectPath =
                          join(newMdObjectLocation, "${newMdObjectName}.md");
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

                      currentItem.children.add(fui.TreeViewItem(
                          content: Text("${newMdObject.objectName}"),
                          value: newMdObject));
                      if (!currentItem.expanded) {
                        currentItem.expanded = true;
                      }
                      _mdTreeItemsNotifier.value++;
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

  newMdObjectPathValid(String path) async {
    if (path.isEmpty) {
      return false;
    }

    return true;
  }
}
