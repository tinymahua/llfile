
import 'package:fluent_ui/fluent_ui.dart' as fui;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:llfile/events/events.dart';
import 'package:llfile/events/md_events.dart';
import 'package:llfile/llpkgs/ll_tab_view/ll_tab_view.dart';
import 'package:llfile/models/markdown_model.dart';
import 'package:llfile/widgets/common/ll_window_widget.dart';
import 'package:llfile/widgets/partials/md_components/ll_md_nav.dart';
import 'package:llfile/widgets/partials/md_components/ll_md_object.dart';

enum LlMdOperateType {
  edit,
  preview,
}


class LlMdObjectHeader extends StatefulWidget {
  LlMdObjectHeader({super.key, required this.mdObject, required this.llMdOperateType});

  MdObject mdObject;


  LlMdOperateType llMdOperateType;

  @override
  State<LlMdObjectHeader> createState() => _LlMdObjectHeaderState();
}

class _LlMdObjectHeaderState extends State<LlMdObjectHeader> {

  LlMdOperateType llMdOperateType = LlMdOperateType.preview;

  @override
  void initState() {
    super.initState();
  }

  setupEvents()async{
    setState(() {
      llMdOperateType = widget.llMdOperateType;
    });
  }

  Widget makeOperateTypeButton(BuildContext context){
    Widget w = Container(
    );
    switch (llMdOperateType){
      case LlMdOperateType.edit:
        w = IconButton(onPressed: (){
          changeMdObjectOperateType(LlMdOperateType.preview);
        }, icon: Icon(Icons.menu_book_outlined));
        break;
      case LlMdOperateType.preview:
        w = IconButton(onPressed: (){
          changeMdObjectOperateType(LlMdOperateType.edit);
        }, icon: Icon(Icons.edit));
        break;
    }
    return w;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(),
        Text("${widget.mdObject.objectName}"),
        Container(child: fui.Padding(
          padding: const EdgeInsets.only(right: 8),
          child: makeOperateTypeButton(context),
        ),),
      ],);
  }

  changeMdObjectOperateType(LlMdOperateType type){
    setState(() {
      llMdOperateType = type;
    });
    eventBus.fire(SwitchMdObjectOperateTypeEvent(mdObject: widget.mdObject, llMdOperateType: type));
  }
}


///
/// Markdown Tab With Content
///
class LlMdObjectTabWidget extends LlTab {
  LlMdObjectTabWidget({
    super.key,
    required this.mdObject,
    required super.body,
    required super.text,
  });

  MdObject mdObject;

  @override
  State<LlTab> createState() => LlMdObjectTabWidgetState();
}

class LlMdObjectTabWidgetState extends LlTabState {
  late fui.FlyoutController _flyoutController;
  final _targetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _flyoutController = fui.FlyoutController();

    setupEvents();
  }

  setupEvents()async{

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
              data: fui.FluentThemeData(), child: super.build(context)),
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

  List<LlMdObjectTabWidget> _mdObjectTabs = [];

  @override
  void initState() {
    super.initState();
    setupEvents();
  }

  setupEvents() async {
    eventBus.on<OpenMdObjectEvent>().listen((evt) {
      var mdObject = evt.mdObject;

      int openedTabIndex = _mdObjectTabs.indexWhere((t)=>t.mdObject.id == mdObject.id);
      if (openedTabIndex < 0){
        if (mdObject.type == MdObjectType.document) {
          final lastIndex = _mdObjectTabs.length;
          LlMdObjectTabWidget newTab = generateMdObjectTab(
              lastIndex + 1, "${mdObject.objectName}", mdObject);
          setState(() {
            _mdObjectTabs.add(newTab);
          });
          setState(() {
            currentIndex = _mdObjectTabs.length - 1;
          });
        } else {}
      }else{
        setState(() {
          currentIndex = openedTabIndex;
        });
      }
    });
  }

  /// Creates a tab for the given index
  LlMdObjectTabWidget generateMdObjectTab(
      int index, String tabTitleText, MdObject mdObject) {

    var mdObjectContentView = mdObject.type == MdObjectType.collection
        ? LlMdCollectionView(
      mdCollection: MdCollection.fromJson(mdObject.data),
    )
        : LlMdDocView(
      mdDocument: MdDocument.fromJson(mdObject.data),
    );

    var mdObjectHeader = LlMdObjectHeader(mdObject: mdObject, llMdOperateType: LlMdOperateType.preview,);

    LlMdObjectTabWidget newTab = LlMdObjectTabWidget(
      mdObject: mdObject,
        body: Column(children: [
          mdObjectHeader,
          Expanded(child: mdObjectContentView),
        ],),
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
                        onNewPressed: () {
                          // final lastIndex = _mdObjectTabs.length;
                          // final newTab = generateMdObjectTab(lastIndex + 1, "New tab");
                          // setState(() {
                          //   _mdObjectTabs.add(newTab);
                          // });
                          // setState(() {
                          //   currentIndex = _mdObjectTabs.length - 1;
                          // });
                        },
                        currentIndex: currentIndex,
                        onChanged: (index) =>
                            setState(() => currentIndex = index),
                        tabWidthBehavior: LlTabWidthBehavior.sizeToContent,
                        closeButtonVisibility:
                            LlCloseButtonVisibilityMode.never,
                        tabs: _mdObjectTabs,
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
