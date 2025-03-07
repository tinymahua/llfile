import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SbcLoginWidget extends StatefulWidget {
  const SbcLoginWidget({super.key});

  @override
  State<SbcLoginWidget> createState() => _SbcLoginWidgetState();
}

class _SbcLoginWidgetState extends State<SbcLoginWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(AppLocalizations.of(context)!.loginFormLabel),
      ],
    );
  }
}
