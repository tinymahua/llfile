import 'package:flutter/widgets.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';

mixin PopOperateMixin {
  popLogin(BuildContext context, Widget child) async{
    var _ = await showTopModalSheet<String?>(context, SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.85,
        child: child), barrierDismissible: false);
  }
}