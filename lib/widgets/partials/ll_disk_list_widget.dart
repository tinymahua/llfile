import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/events/fs_events.dart';
import 'package:llfile/events/path_events.dart';
import 'package:llfile/generated/i10n/app_localizations.dart';
import 'package:llfile/models/fs_model.dart';
import 'package:llfile/src/rust/api/lldisk.dart';
import 'package:llfile/utils/db.dart';
import 'package:llfile/widgets/common/buttons.dart';

enum ContentArea {
  favorite,
  disk,
}

class LlDiskListWidget extends StatefulWidget {
  const LlDiskListWidget({super.key, required this.sidebarFolded});

  final bool sidebarFolded;

  @override
  State<LlDiskListWidget> createState() => _LlDiskListWidgetState();
}

class _LlDiskListWidgetState extends State<LlDiskListWidget> {
  FsFavoriteItemsDb favoriteItemsDb = Get.find<FsFavoriteItemsDb>();

  List<DiskPartition> _disks = [];
  List<FsFavoriteDir> _favoriteDirs = [];
  int _selectedIndex = 0;
  int _hoveredIndex = -1;

  int _selectedFavoriteDirIndex = -1;
  int _hoveredFavoriteDirIndex = -1;

  @override
  void initState() {
    super.initState();
    loadDisks();
    loadFavoriteItems();
    setupEvents();
  }

  loadDisks() async {
    var gotDisks = await getDiskPartitions();
    setState(() {
      _disks = gotDisks;
    });
  }

  loadFavoriteItems()async{
    var favoriteItems = await favoriteItemsDb.read<FsFavoriteItems>();
    setState(() {
      _favoriteDirs = favoriteItems.favoriteDirs;
    });
  }

  setupEvents()async{
    eventBus.on<FsFavoriteDirCreatedEvent>().listen((evt){
      print("Got addfavor event");
      setState(() {
        _favoriteDirs.add(evt.fsFavoriteDir);

      });
    });
  }

  Widget _buildFolded(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List<Widget>.generate(_disks.length, (index) {
        Color selectedColor = _selectedIndex == index
            ? Colors.blue[300]!.withValues(alpha: 0.2)
            : Colors.transparent;
        Color hoveredColor = _hoveredIndex == index
            ? Colors.blue[200]!.withValues(alpha: 0.2)
            : Colors.transparent;

        DiskPartition disk = _disks[index];
        return MouseRegion(
          onHover: (_) {
            setState(() {
              _hoveredIndex = index;
            });
          },
          onExit: (_) {
            setState(() {
              _hoveredIndex = -1;
            });
          },
          child: Container(
            width: 30,
            height: 30,
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: hoveredColor,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                  color: selectedColor,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: TapOrDoubleTapButton(
                child: Text("${disk.mountPoint}"),
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                  eventBus.fire(PathChangeEvent(path: disk.mountPoint));
                },
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildUnfolded(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${AppLocalizations.of(context)!.fsFavoriteTitle}"),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List<Widget>.generate(
            _favoriteDirs.length,
            (index) {
              FsFavoriteDir favoriteDir = _favoriteDirs[index];

              Color selectedFavoriteDirColor = _selectedFavoriteDirIndex == index
                  ? Colors.blue[300]!.withValues(alpha: 0.2)
                  : Colors.transparent;
              Color hoveredFavoriteDirColor = _hoveredFavoriteDirIndex == index
                  ? Colors.blue[200]!.withValues(alpha: 0.2)
                  : Colors.transparent;


              return GestureDetector(
                onTap: () {
                  switchSelectedItem(ContentArea.favorite, index);
                  eventBus.fire(PathChangeEvent(path: favoriteDir.path));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: selectedFavoriteDirColor,
                  ),
                  height: 30,
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: hoveredFavoriteDirColor,
                    ),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onHover: (_) {
                        // print("Hover: ${disk.name}");
                        // setState(() {
                        //   _hoveredFavoriteDirIndex = index;
                        // });
                        switchHoveredItem(ContentArea.favorite, index);
                      },
                      onExit: (_) {
                        switchHoveredItem(ContentArea.favorite, -1);
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 8),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 6,
                            ),
                            const Icon(Icons.folder_outlined, size: 16),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              "${favoriteDir.name}",
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 14,
                                  // fontWeight: FontWeight.w400,
                                  color: Theme.of(context).colorScheme.onSurface),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );

            }
          ),
        ),
        Divider(height: 1,),
        Text("${AppLocalizations.of(context)!.fsMyComputerTitle}"),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List<Widget>.generate(_disks.length, (index) {
            DiskPartition disk = _disks[index];

            Color selectedColor = _selectedIndex == index
                ? Colors.blue[300]!.withValues(alpha: 0.2)
                : Colors.transparent;
            Color hoveredColor = _hoveredIndex == index
                ? Colors.blue[200]!.withValues(alpha: 0.2)
                : Colors.transparent;

            return GestureDetector(
              onTap: () {
                print("Tap: ${disk.name}");
                switchSelectedItem(ContentArea.disk, index);
                eventBus.fire(PathChangeEvent(path: disk.mountPoint));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: selectedColor,
                ),
                height: 30,
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: hoveredColor,
                  ),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onHover: (_) {
                      // print("Hover: ${disk.name}");
                      switchHoveredItem(ContentArea.disk, index);
                    },
                    onExit: (_) {
                      switchHoveredItem(ContentArea.disk, -1);
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 12,
                        ),
                        const Icon(Icons.storage, size: 16),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          "${disk.name.isNotEmpty ? disk.name : AppLocalizations.of(context)!.fsDiskTitle}(${disk.mountPoint})",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                              // fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.sidebarFolded
        ? _buildFolded(context)
        : _buildUnfolded(context);
  }

  switchHoveredItem(ContentArea area, int index){
    if (area == ContentArea.disk) {
      setState(() {
        _hoveredIndex = index;
        // 其他Area
        _hoveredFavoriteDirIndex = -1;
      });
    } else if (area == ContentArea.favorite) {
      setState(() {
        _hoveredFavoriteDirIndex = index;
        // 其他Area
        _hoveredIndex = -1;
      });
    }
  }

  switchSelectedItem(ContentArea area, int index){
    if (area == ContentArea.disk) {
      setState(() {
        _selectedIndex = index;
        // 其他Area
        _selectedFavoriteDirIndex = -1;
      });
    } else if (area == ContentArea.favorite) {
      setState(() {
        _selectedFavoriteDirIndex = index;
        // 其他Area
        _selectedIndex = -1;
      });
    }
  }
}
