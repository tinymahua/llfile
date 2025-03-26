import 'dart:convert';
import 'dart:io';

import 'package:code_text_field/code_text_field.dart';
import 'package:contextmenu/contextmenu.dart';
import 'package:fluent_ui/fluent_ui.dart' as fui;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/kimbie.light.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/events/md_events.dart';
import 'package:llfile/llpkgs/ll_tab_view/ll_tab_view.dart';
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
              : Container()
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
      eventBus.fire(OpenMdDocEvent(mdDocument: MdDocument.fromJson(mdObject.data)));
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


///
/// Markdown Doc View
///
const String edit = "Edit";
const String preview = "Preview";

///
class LlMdDocView extends StatefulWidget {
  const LlMdDocView({super.key});

  @override
  State<LlMdDocView> createState() => _LlMdDocViewState();
}

class _LlMdDocViewState extends State<LlMdDocView> {
  Set<String> selected = {preview};

  PageController _pageController = PageController();
  String _mdContent = "";

  final _codeController = CodeController(
    text: "",
    language: markdown,
  );

  @override
  Widget build(BuildContext context) {
    return  Stack(
      alignment: AlignmentDirectional.topStart,
      children: [PageView(
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
        ),
            Positioned(
              right: 0,
              bottom: 0,
              child: SegmentedButton(
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
                  selected: selected),
            )
      ],
    );
  }
}


///
/// Markdown Tab With Content
///
class LlMdDocTabWidget extends LlTab {
  LlMdDocTabWidget({
    super.key,
    required super.body,
    required super.text,
  });

  @override
  State<LlTab> createState() => LlMdDocTabWidgetState();
}

class LlMdDocTabWidgetState extends LlTabState {
  late fui.FlyoutController _flyoutController;
  final _targetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _flyoutController = fui.FlyoutController();
  }

  void _showMenu(Offset position) {
    _flyoutController.showFlyout(
      position: position,
      builder: (context) {
        return fui.FluentTheme(
          data: fui.FluentThemeData(),
          child: fui.MenuFlyout(
            items: [
              fui.MenuFlyoutItem(
                onPressed: () {
                  debugPrint('Item 1 pressed');
                  Navigator.of(context).maybePop();
                },
                leading: const Icon(fui.FluentIcons.add),
                text: const Text('New tab'),
              ),
              fui.MenuFlyoutItem(
                onPressed: () {
                  debugPrint('Item 2 pressed');
                  Navigator.of(context).maybePop();
                },
                leading: const Icon(fui.FluentIcons.refresh),
                text: const Text('Refresh'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapUp: (d) {
        // This calculates the position of the flyout according to the parent navigator.
        // See https://bdlukaa.github.io/fluent_ui/#/popups/flyout
        final targetContext = _targetKey.currentContext;
        if (targetContext == null) return;
        final box = targetContext.findRenderObject() as RenderBox;
        final position = box.localToGlobal(
          d.localPosition,
          ancestor: Navigator.of(context).context.findRenderObject(),
        );

        _showMenu(position);
      },
      child: fui.FluentTheme(
        data: fui.FluentThemeData(),
        child: fui.FlyoutTarget(
          key: _targetKey,
          controller: _flyoutController,
          child: fui.FluentTheme(
              data: fui.FluentThemeData(),
              child: super.build(context)),
        ),
      ),
    );
  }
}


///
/// Full markdown widget
///
class LlMdWidget extends StatefulWidget {
  const LlMdWidget({super.key});

  @override
  State<LlMdWidget> createState() => _LlMdWidgetState();
}


class _LlMdWidgetState extends State<LlMdWidget> {
  int currentIndex = 0;

  List<LlMdDocTabWidget> _mdDocTabs = [];

  @override
  void initState() {
    super.initState();
    setupEvents();
  }

  setupEvents()async{
    eventBus.on<OpenMdDocEvent>().listen((v){
      final lastIndex = _mdDocTabs.length;
      LlMdDocTabWidget newTab = generateTab(lastIndex+1, "${v.mdDocument.title}");
      setState(() {
        _mdDocTabs.add(newTab);
      });
      setState(() {
        currentIndex = _mdDocTabs.length -1;
      });
    });
  }

  /// Creates a tab for the given index
  LlMdDocTabWidget generateTab(int index, String tabTitleText) {
    LlMdDocTabWidget newTab = LlMdDocTabWidget(
        body: LlMdDocView(),
        text: Text(tabTitleText));
    return newTab;
  }

  Widget _buildSidebar() {
    return LlMdNavTreeWidget();
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
            child: Row(
              children: [
                Expanded(
                  child: fui.FluentTheme(
                    data: fui.FluentThemeData(),
                    child: Container(
                      width: 200,
                      // height: 500,
                      child: LlTabView(
                        addIconData: Icons.add,
                        onNewPressed: (){
                          final lastIndex = _mdDocTabs.length;
                          final newTab = generateTab(lastIndex+1, "New tab");
                          setState(() {
                            _mdDocTabs.add(newTab);
                          });
                          setState(() {
                            currentIndex = _mdDocTabs.length-1;
                          });
                        },
                        currentIndex: currentIndex,
                        onChanged: (index) => setState(() => currentIndex = index),
                        tabWidthBehavior: LlTabWidthBehavior.sizeToContent,
                        closeButtonVisibility: LlCloseButtonVisibilityMode.never,
                        tabs: _mdDocTabs,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
