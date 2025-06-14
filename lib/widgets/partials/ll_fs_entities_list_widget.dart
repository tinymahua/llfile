import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/events/fs_events.dart';
import 'package:llfile/events/path_events.dart';
import 'package:llfile/events/sbn_events.dart';
import 'package:llfile/mixins/sbn_mixin.dart';
import 'package:llfile/models/app_config_model.dart';
import 'package:llfile/models/fs_model.dart';
import 'package:llfile/models/operate_record_model.dart';
import 'package:llfile/models/path_model.dart';
import 'package:llfile/models/types.dart';
import 'package:llfile/src/rust/api/llfs.dart';
import 'package:llfile/generated/i10n/app_localizations.dart';
import 'package:llfile/tasks/fs_tasks.dart';
import 'package:llfile/utils/db.dart';
import 'package:llfile/widgets/common/context_menu_widget.dart';
import 'package:multi_column_list_view/multi_column_list_view.dart';
import 'package:path/path.dart' hide context;
import 'package:contextmenu/contextmenu.dart';


class LlFsEntitiesListWidget extends StatefulWidget {
  const LlFsEntitiesListWidget({super.key, required this.tabIndex});

  final int tabIndex;

  @override
  State<LlFsEntitiesListWidget> createState() => _LlFsEntitiesListWidgetState();
}

class _LlFsEntitiesListWidgetState extends State<LlFsEntitiesListWidget> with SbnMixin{
  FsFavoriteItemsDb favoriteItemsDb = Get.find<FsFavoriteItemsDb>();

  final MultiColumnListController _fsEntitiesMultiColumnListController =
      MultiColumnListController();
  late Stream<FsEntity> _fsEntitiesStream;
  String _currentFsPath = '';
  final _pathHistoryDb = Get.find<PathHistoryDb>();
  final _appStatesMemDb = Get.find<AppStatesMemDb>();
  final _appConfigDb = Get.find<AppConfigDb>();
  AppConfig? _appConfig;
  TextEditingController _renameTextEditingController = TextEditingController();
  TextEditingController _newFolderTextEditingController = TextEditingController();

  bool _sandbarNodeReady = false;

  @override
  void initState() {
    super.initState();
    setupEvents();
  }

  setupEvents() async {
    eventBus.on<PathChangeEvent>().listen((evt) {
      print("Evt: $evt");
      if (_appStatesMemDb.activatedFileBrowserTabIdx == widget.tabIndex) {
        setState(() {
          _currentFsPath = evt.path;
        });
        retrieveFsEntities();
      }
    });

    _appConfig = await _appConfigDb.read<AppConfig>();

    var sandbarNodeReady = await isReady(_appConfig);
    setState(() {
      _sandbarNodeReady = sandbarNodeReady;
    });
    eventBus.on<SbnReadyEvent>().listen((evt){
      setState(() {
        _sandbarNodeReady = evt.ready;
      });
    });
  }

  retrieveFsEntities() async {
    String requestFsPath = _currentFsPath;
    if (!requestFsPath.endsWith(Platform.pathSeparator)) {
      requestFsPath += Platform.pathSeparator;
    }

    var fsEntitiesStream = getFsEntities(rootPath: requestFsPath);

    var pathHistories = await _pathHistoryDb.read<PathHistories>();
    if (pathHistories.histories.isEmpty ||
        pathHistories.histories.last != _currentFsPath) {
      await _pathHistoryDb.addHistory(_currentFsPath);
    }

    setState(() {
      _fsEntitiesMultiColumnListController.rows.value = [];
      _fsEntitiesStream = fsEntitiesStream;
    });

    _fsEntitiesStream.listen((evt) {
      setState(() {
        _fsEntitiesMultiColumnListController.rows.value.add(evt);
      });
    });
  }

  Widget _buildFileIcon(FsEntity fsEntity) {
    String iconResource = '';
    if (_appConfig != null) {
      var fIcon =
          _appConfig!.fileIcons[fsEntity.name.split('.').last.toLowerCase()];
      if (fIcon != null) {
        iconResource = fIcon.resource;
      }
    }

    return iconResource.isNotEmpty
        ? ImageIcon(
            FileImage(File(iconResource)),
            color: Theme.of(context).colorScheme.primary,
            size: 16,
          )
        : Icon(
            Icons.file_copy,
            color: Theme.of(context).colorScheme.primary,
            size: 16,
          );
  }

  Widget _buildDirIcon(FsEntity fsEntity) {
    return Icon(
      Icons.folder,
      size: 20,
      color: Theme.of(context).colorScheme.primary,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<double> multiColumnWidths = [
      300,
      200,
      100,
    ];
    List<Widget> multiColumnTitles = [
      Text(AppLocalizations.of(context)!.fsEntitiesTableHeaderName),
      Text(AppLocalizations.of(context)!.fsEntitiesTableHeaderDate),
      Text(AppLocalizations.of(context)!.fsEntitiesTableHeaderType),
    ];

    return MultiColumnListView(
      dataRowHeight: 30,
      optimizeListRender: true,
      controller: _fsEntitiesMultiColumnListController,
      rowCellsBuilder: (BuildContext context, int rowIndex) {
        FsEntity fsEntity = _fsEntitiesMultiColumnListController
            .rows.value[rowIndex] as FsEntity;
        var ext = '';
        if (!fsEntity.isDir && fsEntity.name.contains(".")) {
          ext = fsEntity.name.split(".").toList().last;
        }

        return [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              fsEntity.isDir
                  ? _buildDirIcon(fsEntity)
                  : _buildFileIcon(fsEntity),
              Container(
                padding: EdgeInsets.only(left: 4),
                child: Text(
                  fsEntity.name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    overflow: TextOverflow.ellipsis,
                    // fontWeight: FontWeight.w100,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ],
          ),
          Text(
            fsEntity.dateCreated,
            style: TextStyle(
              color: Theme.of(context).appBarTheme.foregroundColor,
              // fontWeight: FontWeight.w700,
              fontSize: 12.0,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            ext,
            style: TextStyle(
              color: Theme.of(context).appBarTheme.foregroundColor,
              // fontWeight: FontWeight.w900,
              fontSize: 12.0,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          //     )],
          // )
        ];
      },
      tappedRowColor: Colors.blue[300]!.withValues(alpha: 0.2),
      hoveredRowColor: Colors.blue[200]!.withValues(alpha: 0.2),
      onRowTap: onFsEntityRowTap,
      onRowDoubleTap: onFsEntityRowDoubleTap,
      onRowContextMenu: onFsEntityRowContextMenu,
      onListContextMenu: onFsEntityListContextMenu,
      columnWidths: multiColumnWidths,
      columnTitles: multiColumnTitles,
      debug: true,
    );
  }

  onFsEntityRowTap(int index) {
    print("FileSystem Entity Row Tapped");
    eventBus.fire(PreviewFsEntityEvent(fsPath: _currentFsPath, fsEntity: _fsEntitiesMultiColumnListController.rows.value[index]));
  }

  onFsEntityRowDoubleTap(int index) {
    print("FileSystem Entity Row Double Tapped");
    var fsEntity =
        _fsEntitiesMultiColumnListController.rows.value[index] as FsEntity;
    if (fsEntity.isDir) {
      var newPath = join(_currentFsPath, fsEntity.name);
      eventBus.fire(PathChangeEvent(path: newPath));
    }
  }

  getFileContextMenuViews(FsEntity fsEntity){
    var iconSize = 18.0;
    var iconWeight = 8.0;
    var fsEntityPath = join(_currentFsPath, fsEntity.name);
    return [
      ContextMenuView(
          divider: Divider(
            height: 1,
          ),
          menuSections: [
            [
              ContextMenuItem(
                onTap: () {
                  onCopyOrCut(fsEntityPath);
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.copy_all_outlined,
                  size: iconSize,
                  weight: iconWeight,
                ),
                title: Text(AppLocalizations.of(context)!.contextMenuCopy),
                shortcut: "",
              ),
              ContextMenuItem(
                onTap: () {
                  onCopyOrCut(fsEntityPath, isCopy: false);
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.cut_outlined,
                  size: iconSize,
                  weight: iconWeight,
                ),
                title: Text(AppLocalizations.of(context)!.contextMenuCut),
                shortcut: "",
              ),
            ],
            _sandbarNodeReady ? [
              ContextMenuItem(
                onTap: () {
                  onAddToSandbarFs(fsEntityPath);
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.drive_folder_upload,
                  size: iconSize,
                  weight: iconWeight,
                ),
                title: Text(AppLocalizations.of(context)!.contextMenuAddToSandbarFs),
                shortcut: "",
              ),
            ]: [],
            [
              ContextMenuItem(
                onTap: () {
                  Navigator.of(context).pop();
                  onRename(fsEntityPath);
                },
                icon: Icon(
                  Icons.drive_file_rename_outline_rounded,
                  size: iconSize,
                  weight: iconWeight,
                ),
                title: Text(AppLocalizations.of(context)!.contextMenuRename),
                shortcut: "",
              ),
              ContextMenuItem(
                onTap: () {
                  onDelete(fsEntityPath);
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.delete,
                  size: iconSize,
                  weight: iconWeight,
                ),
                title: Text(AppLocalizations.of(context)!.contextMenuDelete),
                shortcut: "",
              )
            ]
          ]),
    ];
  }

  getDirContextMenuViews(FsEntity fsEntity){
    var iconSize = 18.0;
    var iconWeight = 8.0;
    var fsEntityPath = join(_currentFsPath, fsEntity.name);
    return [
      ContextMenuView(
          divider: Divider(
            height: 1,
          ),
          menuSections: [
            [
              ContextMenuItem(
                onTap: () {
                  onAddFavorite(fsEntity);
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.star_border,
                  size: iconSize,
                  weight: iconWeight,
                ),
                title: Text(AppLocalizations.of(context)!.contextMenuAddFavorite),
                shortcut: "",
              ),
            ],
            [
              ContextMenuItem(
                onTap: () {
                  onCopyOrCut(fsEntityPath);
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.copy_all_outlined,
                  size: iconSize,
                  weight: iconWeight,
                ),
                title: Text(AppLocalizations.of(context)!.contextMenuCopy),
                shortcut: "",
              ),
              ContextMenuItem(
                onTap: () {
                  onCopyOrCut(fsEntityPath, isCopy: false);
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.cut_outlined,
                  size: iconSize,
                  weight: iconWeight,
                ),
                title: Text(AppLocalizations.of(context)!.contextMenuCut),
                shortcut: "",
              ),
            ],
            _sandbarNodeReady ? [
              ContextMenuItem(
                onTap: () {
                  onAddToSandbarFs(fsEntityPath);
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.drive_folder_upload,
                  size: iconSize,
                  weight: iconWeight,
                ),
                title: Text(AppLocalizations.of(context)!.contextMenuAddToSandbarFs),
                shortcut: "",
              ),
            ]: [],
            [
              ContextMenuItem(
                onTap: () {
                  Navigator.of(context).pop();
                  onRename(fsEntityPath);
                },
                icon: Icon(
                  Icons.drive_file_rename_outline_rounded,
                  size: iconSize,
                  weight: iconWeight,
                ),
                title: Text(AppLocalizations.of(context)!.contextMenuRename),
                shortcut: "",
              ),
              ContextMenuItem(
                onTap: () {
                  onDelete(fsEntityPath);
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.delete,
                  size: iconSize,
                  weight: iconWeight,
                ),
                title: Text(AppLocalizations.of(context)!.contextMenuDelete),
                shortcut: "",
              )
            ]
          ]),
    ];
  }

  getContextMenuContextViews(FsEntity? fsEntity) {
    var iconSize = 18.0;
    var iconWeight = 8.0;
    List<ContextMenuView> contextMenuViews = [];

    if (fsEntity != null) {
      // var fsEntityPath = join(_currentFsPath, fsEntity.name);
      // contextMenuViews = [
      //   ContextMenuView(
      //       divider: Divider(
      //         height: 1,
      //       ),
      //       menuSections: [
      //         [
      //           ContextMenuItem(
      //             onTap: () {
      //               onCopyOrCut(fsEntityPath);
      //               Navigator.of(context).pop();
      //             },
      //             icon: Icon(
      //               Icons.copy_all_outlined,
      //               size: iconSize,
      //               weight: iconWeight,
      //             ),
      //             title: Text(AppLocalizations.of(context)!.contextMenuCopy),
      //             shortcut: "",
      //           ),
      //           ContextMenuItem(
      //             onTap: () {
      //               onCopyOrCut(fsEntityPath, isCopy: false);
      //               Navigator.of(context).pop();
      //             },
      //             icon: Icon(
      //               Icons.cut_outlined,
      //               size: iconSize,
      //               weight: iconWeight,
      //             ),
      //             title: Text(AppLocalizations.of(context)!.contextMenuCut),
      //             shortcut: "",
      //           ),
      //         ],
      //         _sandbarNodeReady ? [
      //           ContextMenuItem(
      //             onTap: () {
      //               onAddToSandbarFs(fsEntityPath);
      //               Navigator.of(context).pop();
      //             },
      //             icon: Icon(
      //               Icons.drive_folder_upload,
      //               size: iconSize,
      //               weight: iconWeight,
      //             ),
      //             title: Text(AppLocalizations.of(context)!.contextMenuAddToSandbarFs),
      //             shortcut: "",
      //           ),
      //         ]: [],
      //         [
      //           ContextMenuItem(
      //             onTap: () {
      //               Navigator.of(context).pop();
      //               onRename(fsEntityPath);
      //             },
      //             icon: Icon(
      //               Icons.drive_file_rename_outline_rounded,
      //               size: iconSize,
      //               weight: iconWeight,
      //             ),
      //             title: Text(AppLocalizations.of(context)!.contextMenuRename),
      //             shortcut: "",
      //           ),
      //           ContextMenuItem(
      //             onTap: () {
      //               onDelete(fsEntityPath);
      //               Navigator.of(context).pop();
      //             },
      //             icon: Icon(
      //               Icons.delete,
      //               size: iconSize,
      //               weight: iconWeight,
      //             ),
      //             title: Text(AppLocalizations.of(context)!.contextMenuDelete),
      //             shortcut: "",
      //           )
      //         ]
      //       ]),
      // ];
      //
      if (fsEntity.isDir){
        contextMenuViews = getDirContextMenuViews(fsEntity);
      }else{
        contextMenuViews = getFileContextMenuViews(fsEntity);
      }
    } else {
      contextMenuViews = [
        ContextMenuView(
          menuSections: [
            [
              ContextMenuItem(
                onTap: () {
                  onPaste();
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.paste_outlined,
                  size: iconSize,
                  weight: iconWeight,
                ),
                title: Text(AppLocalizations.of(context)!.contextMenuPaste),
                shortcut: "",
              ),
              ContextMenuItem(
                onTap: () {
                  Navigator.of(context).pop();
                  onNewDir();
                },
                icon: Icon(
                  Icons.create_new_folder_outlined,
                  size: iconSize,
                  weight: iconWeight,
                ),
                title: Text(AppLocalizations.of(context)!.contextMenuNewFolder),
                shortcut: "",
              ),
            ]
          ],
          divider: Divider(
            height: 1,
          ),
        )
      ];
    }
    return contextMenuViews;
  }

  onFsEntityRowContextMenu(TapDownDetails details, int index) {
    var fsEntity =
        _fsEntitiesMultiColumnListController.rows.value[index] as FsEntity;
    print("FileSystem Entity Row Context Menu Opened");
    showContextMenu(details.globalPosition, context, (BuildContext context) {
      return getContextMenuContextViews(fsEntity);
    }, 0.0, 240.0);
  }

  onFsEntityListContextMenu(TapDownDetails details) {
    print("FileSystem Entity List Context Menu Opened");
    showContextMenu(details.globalPosition, context, (BuildContext context) {
      return getContextMenuContextViews(null);
    }, 8.0, 240.0);
  }

  onAddFavorite(FsEntity fsEntity)async{
    var favoriteDir = FsFavoriteDir(name: fsEntity.name, path: join(_currentFsPath, fsEntity.name));
    await favoriteItemsDb.addFavoriteDir(favoriteDir);
    eventBus.fire(FsFavoriteDirCreatedEvent(favoriteDir));
  }
  
  onCopyOrCut(String fsEntityPath, {bool isCopy = true}) async {
    _appStatesMemDb.copyOrCutOperateRecord = OperateRecord(
        type: isCopy ? OperateType.copy : OperateType.cut,
        targetType: OperateTargetType.file,
        targetPath: fsEntityPath);
    Get.put(_appStatesMemDb);
  }

  onPaste() async {
    var copyOrCutOperateRecord = _appStatesMemDb.copyOrCutOperateRecord;
    if (copyOrCutOperateRecord != null) {
      print("Get operate object: ${copyOrCutOperateRecord.toJson()}");
      if (copyOrCutOperateRecord.type == OperateType.copy) {
        if (copyOrCutOperateRecord.targetType == OperateTargetType.file) {
          bool isCut = false;
          String srcPath = copyOrCutOperateRecord.targetPath;
          String destPath = join(_currentFsPath, basename(srcPath));
          eventBus.fire(CopyFileTaskWidget(
            srcPath: srcPath,
            destPath: destPath,
            isCut: isCut,
          ));
        }
      } else if (copyOrCutOperateRecord.type == OperateType.cut) {
        if (copyOrCutOperateRecord.targetType == OperateTargetType.file) {
          bool isCut = true;
          String srcPath = copyOrCutOperateRecord.targetPath;
          String destPath = join(_currentFsPath, basename(srcPath));
          eventBus.fire(CopyFileTaskWidget(
            srcPath: srcPath,
            destPath: destPath,
            isCut: isCut,
          ));
        }
      }
    }
  }

  onAddToSandbarFs(String fsEntityPath)async {
    eventBus.fire(AddToSandbarFsTaskWidget(
      fsEntityPath
    ));
  }

  onNewDir()async{
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.contextMenuNewFolder),
            content: Container(
              child: TextField(
                controller: _newFolderTextEditingController,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.cancelLabel)),
              TextButton(
                  onPressed: () {
                    String newFolderName = _newFolderTextEditingController.text.trim();
                    if (newFolderName.isNotEmpty) {
                      if (!newFsEntityNameValid(newFolderName)) {
                        return;
                      }
                      var newDirPath = join(_currentFsPath, newFolderName);
                      if (!Directory(newDirPath).existsSync()) {
                        Directory(newDirPath).createSync();
                      }
                    }
                    Navigator.of(context).pop();
                    eventBus.fire(PathChangeEvent(path: _currentFsPath));
                  },
                  child: Text(AppLocalizations.of(context)!.okLabel))
            ],
          );
        });

  }

  onDelete(String fsEntityPath) async {
    if (FileSystemEntity.isFileSync(fsEntityPath)) {
      eventBus.fire(DeleteFileTaskWidget(fsEntityPath));
    }
  }

  onRename(String fsEntityPath) async {
    String oldName = basename(fsEntityPath);
    setState(() {
      _renameTextEditingController.text = oldName;
    });
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.contextMenuRename),
            content: Container(
              child: TextField(
                controller: _renameTextEditingController,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.cancelLabel)),
              TextButton(
                  onPressed: () {
                    if (_renameTextEditingController.text.trim() != oldName) {
                      if (!newFsEntityNameValid(
                          _renameTextEditingController.text.trim())) {
                        return;
                      }
                      var newPath = join(dirname(fsEntityPath),
                          _renameTextEditingController.text.trim());
                      if (FileSystemEntity.isFileSync(fsEntityPath)) {
                        File(fsEntityPath).renameSync(newPath);
                      } else {
                        Directory(fsEntityPath).renameSync(newPath);
                      }
                    }
                    Navigator.of(context).pop();
                    eventBus.fire(PathChangeEvent(path: _currentFsPath));
                  },
                  child: Text(AppLocalizations.of(context)!.okLabel))
            ],
          );
        });
  }

  onDetail() async {
    // TODO
  }

  @override
  void dispose() {
    print("Tab: ${widget.tabIndex} disposed.");
    super.dispose();
  }

  newFsEntityNameValid(String name) {
    if (name.isEmpty) {
      return false;
    }
    if (name.contains(RegExp(r'[/\\:*?"<>|]'))) {
      return false;
    }
    return true;
  }
}
