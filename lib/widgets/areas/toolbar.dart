import 'package:flutter/material.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/events/layout_events.dart';
import 'package:window_manager/window_manager.dart';

class LlToolbar extends StatefulWidget {
  const LlToolbar({super.key});

  @override
  State<LlToolbar> createState() => _LlToolbarState();
}



class _LlToolbarState extends State<LlToolbar> {
  bool _isMaximized = false;

  toggleSidebarSwitch(){
    eventBus.fire(ToggleSidebarSwitchEvent());
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      // 这里可以设置工具栏的高度等样式属性
      height: 50,
      color: Colors.grey[300],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 折叠侧边栏按钮
          IconButton(
            icon: Icon(
              Icons.view_sidebar_outlined,
              weight: 0.6,
              size: Theme.of(context).appBarTheme.iconTheme!.size,
              color: Theme.of(context).appBarTheme.iconTheme!.color!,
            ),
            onPressed: () {
              toggleSidebarSwitch();
            },
          ),
          // 放置最小化、最大化、关闭按钮的Row
          Row(
            children: [
              IconButton(
                alignment: Alignment.center,
                icon: Icon(
                  Icons.horizontal_rule_rounded,
                  size: Theme.of(context).appBarTheme.iconTheme!.size,
                  color: Theme.of(context).appBarTheme.iconTheme!.color!,
                ),
                onPressed: () {
                  windowManager.minimize();
                },
              ),
              IconButton(
                icon: Icon(
                  _isMaximized ? Icons.fullscreen_exit : Icons.fullscreen,
                  size: Theme.of(context).appBarTheme.iconTheme!.size,
                  color: Theme.of(context).appBarTheme.iconTheme!.color!,
                ),
                onPressed: _isMaximized
                    ? () {
                        windowManager.restore();
                        setState(() {
                          _isMaximized = false;
                        });
                      }
                    : () {
                        windowManager.maximize();
                        setState(() {
                          _isMaximized = true;
                        });
                      },
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  size: Theme.of(context).appBarTheme.iconTheme!.size,
                  color: Theme.of(context).appBarTheme.iconTheme!.color!,
                ),
                onPressed: () {
                  windowManager.close();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
