import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:llfile/widgets/partials/sbc_login_widget.dart';
import 'package:llfile/widgets/partials/sbc_register_widget.dart';

class LoginOrRegisterWidget extends StatefulWidget {
  const LoginOrRegisterWidget({super.key});

  @override
  State<LoginOrRegisterWidget> createState() => _LoginOrRegisterWidgetState();
}

const String loginActId = 'login';
const String registerActId = 'register';

class _LoginOrRegisterWidgetState extends State<LoginOrRegisterWidget> {
  Set<String> selected = {loginActId};

  String get selectedActId => selected.first;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SegmentedButton(
              showSelectedIcon: false,
              segments: [
                ButtonSegment<String>(
                    value: loginActId,
                    label:
                        Text(AppLocalizations.of(context)!.loginButtonLabel)),
                ButtonSegment<String>(
                    value: registerActId,
                    label: Text(
                        AppLocalizations.of(context)!.registerButtonLabel)),
              ],
              selected: selected,
              onSelectionChanged: (Set<String> newSelected) {
                setState(() {
                  selected = newSelected;
                });
              },
            )
          ],
        ),
        SizedBox(height: 10,),
        buildForm(),
      ],
    );
  }

  Widget buildForm(){
    Widget w = Container();
    if (selectedActId == loginActId){
      w = SbcLoginWidget();
    }
    if (selectedActId == registerActId){
      w = SbcRegisterWidget();
    }
    return w;
  }
}
