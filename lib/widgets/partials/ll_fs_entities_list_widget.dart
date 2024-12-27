import 'dart:io';
import 'package:flutter/material.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/events/path_events.dart';
import 'package:llfile/src/rust/api/llfs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multi_column_list_view/multi_column_list_view.dart';

class LlFsEntitiesListWidget extends StatefulWidget {
  const LlFsEntitiesListWidget({super.key});

  @override
  State<LlFsEntitiesListWidget> createState() => _LlFsEntitiesListWidgetState();
}

class _LlFsEntitiesListWidgetState extends State<LlFsEntitiesListWidget> {
  final MultiColumnListController _fsEntitiesMultiColumnListController =
      MultiColumnListController();
  late Stream<FsEntity> _fsEntitiesStream;
  String _currentFsPath = '';

  @override
  void initState() {
    super.initState();
    setupEvents();
  }

  setupEvents() {
    eventBus.on<PathChangeEvent>().listen((evt) {
      print("Evt: $evt");
      setState(() {
        _currentFsPath = evt.path;
      });
      retrieveFsEntities();
    });
  }

  retrieveFsEntities() {
    String requestFsPath = _currentFsPath;
    if (!requestFsPath.endsWith(Platform.pathSeparator)) {
      requestFsPath += Platform.pathSeparator;
    }

    var fsEntitiesStream = getFsEntities(rootPath: requestFsPath);

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
      controller: _fsEntitiesMultiColumnListController,
      rowCellsBuilder: (BuildContext context, int rowIndex) {
        FsEntity fsEntity = _fsEntitiesMultiColumnListController
            .rows.value[rowIndex] as FsEntity;
        var ext = '';
        if (!fsEntity.isDir && fsEntity.name.contains(".")) {
          ext = fsEntity.name.split(".").toList().last;
        }
        return [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  fsEntity.isDir ? Icons.folder : Icons.file_copy,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Container(
                  padding: EdgeInsets.only(left: 4),
                  child: Text(
                    fsEntity.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w900,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              // width: multiColumnWidths[1],
              // padding: EdgeInsets.only(left: 10),
              child: Text(
                fsEntity.dateCreated,
                style: TextStyle(
                  color: Theme.of(context).appBarTheme.foregroundColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 12.0,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              // width: multiColumnWidths[2],
              // padding: EdgeInsets.only(left: 10),
              child: Text(
                ext,
                style: TextStyle(
                  color: Theme.of(context).appBarTheme.foregroundColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 12.0,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          )
        ];
      },
      tappedRowColor: Colors.blue.withOpacity(0.2),
      hoveredRowColor: Colors.grey.withOpacity(0.2),
      onRowTap: onFsEntityRowTap,
      onRowDoubleTap: onFsEntityRowDoubleTap,
      onRowContextMenu: onFsEntityRowContextMenu,
      columnWidths: multiColumnWidths,
      columnTitles: multiColumnTitles,
    );
  }

  onFsEntityRowTap(int index) {
    print("FileSystem Entity Row Tapped");
  }

  onFsEntityRowDoubleTap(int index) {
    print("FileSystem Entity Row Double Tapped");
  }

  onFsEntityRowContextMenu(TapDownDetails details, int index) {
    print("FileSystem Entity Row Context Menu Opened");
  }
}
