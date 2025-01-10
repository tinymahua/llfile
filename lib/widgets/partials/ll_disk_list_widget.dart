import 'package:flutter/material.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/events/path_events.dart';
import 'package:llfile/src/rust/api/lldisk.dart';
import 'package:llfile/widgets/common/buttons.dart';

class LlDiskListWidget extends StatefulWidget {
  const LlDiskListWidget({super.key, required this.sidebarFolded});

  final bool sidebarFolded;

  @override
  State<LlDiskListWidget> createState() => _LlDiskListWidgetState();
}

class _LlDiskListWidgetState extends State<LlDiskListWidget> {
  List<DiskPartition> _disks = [];
  int _selectedIndex = 0;
  int _hoveredIndex = -1;

  @override
  void initState() {
    super.initState();
    loadDisks();
  }

  loadDisks()async{
    setState(() {
      _disks = getDiskPartitions();
    });
  }

  Widget _buildFolded(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List<Widget>.generate(
        _disks.length,
          (index){
            Color selectedColor = _selectedIndex == index
                ? Colors.grey.withOpacity(0.2)
                : Colors.transparent;
            Color hoveredColor = _hoveredIndex == index
                ? Colors.lightBlueAccent.withOpacity(0.2)
                : Colors.transparent;

            DiskPartition disk = _disks[index];
          return MouseRegion(
            onHover: (_){
              setState(() {
                _hoveredIndex = index;
              });
            },
            onExit: (_){
              setState(() {
                _hoveredIndex = -1;
              });
            },
            child: Container(
              width: 30,
              height: 30,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(color: hoveredColor, borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Container(
                padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(color: selectedColor, borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: TapOrDoubleTapButton(child: Text("${disk.mountPoint}"), onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                    eventBus.fire(PathChangeEvent(path: disk.mountPoint));
                  },),
                ),

            ),
          );
          }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.sidebarFolded? _buildFolded(context): Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List<Widget>.generate(_disks.length, (index) {
        DiskPartition disk = _disks[index];

        Color selectedColor = _selectedIndex == index
            ? Colors.grey.withOpacity(0.2)
            : Colors.transparent;
        Color hoveredColor = _hoveredIndex == index
            ? Colors.lightBlueAccent.withOpacity(0.2)
            : Colors.transparent;

        return GestureDetector(
          onTap: () {
            print("Tap: ${disk.name}");
            setState(() {
              _selectedIndex = index;
            });
            eventBus.fire(PathChangeEvent(path: disk.mountPoint));
          },
          child: Container(
            decoration: BoxDecoration(color: selectedColor,),
            height: 30,
            child: Container(
              height: 30,
              decoration: BoxDecoration(color: hoveredColor,),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                onHover: (_){
                  // print("Hover: ${disk.name}");
                  setState(() {
                    _hoveredIndex = index;
                  });
                },
                onExit: (_){
                  setState(() {
                    _hoveredIndex = -1;
                  });
                },
                child: Row(
                    children: [
                      SizedBox(width: 6,),
                      const Icon(Icons.storage, size: 16),
                      SizedBox(width: 4,),
                      Text(
                        "${disk.name.isNotEmpty ? disk.name : "新加卷"}(${disk.mountPoint})",
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ],
                  ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

