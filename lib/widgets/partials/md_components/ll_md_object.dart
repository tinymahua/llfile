import 'dart:io';

import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/kimbie.light.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:highlight/languages/markdown.dart';
import 'package:llfile/models/markdown_model.dart';
import 'package:llfile/widgets/common/keep_alive_wrapper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

///
/// Markdown Doc View
///
const String edit = "Edit";
const String preview = "Preview";

///
class LlMdDocView extends StatefulWidget {
  LlMdDocView({super.key, required this.mdDocument});

  MdDocument mdDocument;

  @override
  State<LlMdDocView> createState() => _LlMdDocViewState();
}

class _LlMdDocViewState extends State<LlMdDocView> {
  Set<String> selected = {preview};

  PageController _pageController = PageController();
  String _mdContent = "";
  String _mdDocFsPath = "";

  final _codeController = CodeController(
    text: "",
    language: markdown,
  );

  @override
  void initState() {
    super.initState();
    setupEvents();
  }

  setupEvents()async{
    setState(() {
      _mdDocFsPath = widget.mdDocument.fsPath;
    });

    var mdContent = File(_mdDocFsPath).readAsStringSync();
    setState(() {
      _mdContent = mdContent;
      _codeController.text = mdContent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: [
        PageView(
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
                              mdContentChanged(text);
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

  mdContentChanged(String mdContent)async {
    setState(() {
      _mdContent = mdContent;
    });
    Future.delayed(Duration(seconds: 3), (){
      File(_mdDocFsPath).writeAsStringSync(mdContent);
    });
  }
}

///
/// Markdown Collection View
///
class LlMdCollectionView extends StatefulWidget {
  LlMdCollectionView({super.key, required this.mdCollection});

  MdCollection mdCollection;

  @override
  State<LlMdCollectionView> createState() => _LlMdCollectionViewState();
}

class _LlMdCollectionViewState extends State<LlMdCollectionView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
