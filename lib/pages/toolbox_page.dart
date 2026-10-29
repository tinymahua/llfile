import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:llfile/pages/toolbox_types.dart';
import 'package:window_manager/window_manager.dart';

class ToolBoxPage extends StatefulWidget {
  const ToolBoxPage({super.key});

  @override
  State<ToolBoxPage> createState() => _ToolBoxPageState();
}

class _ToolBoxPageState extends State<ToolBoxPage> {
  final List<ToolboxItem> _items = [];
  bool _isDragging = false;

  // 0.8.x 中 DropDoneDetails.files 为文件列表，元素含 path（通常为本地路径），
  // 个别场景带 file:// 前缀，这里做一层归一化
  String? _normalizePath(String raw) {
    if (raw.isEmpty) return null;
    if (raw.startsWith('file://')) {
      return Uri.parse(raw).toFilePath();
    }
    return raw;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Column(
        children: [
          DragToMoveArea(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
              ),
              child: const Row(
                children: [
                  SizedBox(width: 12),
                  Text(
                    '百宝箱',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: DropTarget(
              onDragDone: (details) {
                setState(() => _isDragging = false);
                for (final file in details.files) {
                  final path = _normalizePath(file.path);
                  if (path != null) {
                    setState(() {
                      _items.add(ToolboxItem.fromPath(path));
                    });
                  }
                }
              },
              onDragEntered: (_) {
                setState(() => _isDragging = true);
              },
              onDragExited: (_) {
                setState(() => _isDragging = false);
              },
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _isDragging ? Colors.blue : Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _items.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.inbox_outlined,
                                size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              '将文件或目录拖入此处开始操作',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: _items.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final item = _items[index];
                          return ListTile(
                            leading: Icon(item.icon),
                            title: Text(item.name),
                            subtitle: Text(
                                '${item.typeLabel} · ${item.sizeLabel}'),
                            trailing: Tooltip(
                              message: item.path,
                              child: const Icon(Icons.info_outline,
                                  color: Colors.grey),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
