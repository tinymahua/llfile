import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:llfile/models/app_config_model.dart';
import 'package:llfile/modules/settings/settings_values.dart';
import 'package:llfile/utils/db.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LlLanguageSetting extends SettingsContentPageBaseWidget {
  const LlLanguageSetting({super.key}): super(pageName: SettingsContentPage.language);

  @override
  State<LlLanguageSetting> createState() => _LlLanguageSettingState();
}


class LangArea {
  String areaCode;
  String areaLabel;

  LangArea(this.areaCode, this.areaLabel);

  @override
  int get hashCode => areaCode.hashCode;

  @override
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
  }
}


class LangLocale {
  String langCode;
  String langLabel;
  List<LangArea> langAreas;

  LangLocale(this.langCode, this.langLabel, this.langAreas);

  @override
  int get hashCode => langCode.hashCode;

  @override
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
  }
}


Map<String, LangLocale> langLocalesMap = {
  'zh': LangLocale('zh', '中文简体', [LangArea('CN', '中国')]),
  'en': LangLocale('en', '英语', [LangArea('US', '美国'), LangArea('UK', '英国')]),
};

List<LangLocale> langLocales = langLocalesMap.values.toList();


class _LlLanguageSettingState extends State<LlLanguageSetting> {
  AppConfigDb _appConfigDb = Get.find<AppConfigDb>();
  AppConfig? _appConfig;
  LanguageConfig? _languageConfig;

  LangLocale? _selectedLangLocale;
  LangArea? _selectedLangArea;
  List<LangArea> _langAreas = [];

  @override
  void initState() {
    super.initState();
    setupEvents();
  }

  setupEvents() async {
    _appConfig = await _appConfigDb.read<AppConfig>();
    LanguageConfig _languageConfig = _appConfig!.preferences.language;
    selectLangLocale(langLocalesMap[_languageConfig.languageCode]!);
    selectLangArea(_selectedLangLocale!.langAreas.firstWhere((e)=>e.areaCode == _languageConfig.countryCode));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                      // width: 120,
                      child: Text(AppLocalizations.of(context)!
                          .settingsLanguageLanguageCode)),
                  SizedBox(width: 12,),
                  Container(
                    // height: 24,
                    child: DropdownButton<LangLocale>(
                      value: _selectedLangLocale,
                        items: List<DropdownMenuItem<LangLocale>>.generate(
                            langLocales.length, (index) {
                          return DropdownMenuItem(
                              value: langLocales[index],
                              child: Text(langLocales[index].langLabel, locale: Localizations.localeOf(context),));
                        }),
                        onChanged: (v) {
                          print("${v}");
                          selectLangLocale(v!);
                        }),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                      // width: 120,
                      child: Text(AppLocalizations.of(context)!
                          .settingsLanguageCountryCode)),
                  SizedBox(width: 12,),
                  Container(
                    child: DropdownButton<LangArea>(
                        value: _selectedLangArea,
                        items: List<DropdownMenuItem<LangArea>>.generate(
                      _langAreas.length, (index) {
                        return DropdownMenuItem(
                            value: _langAreas[index],
                            child: Text(_langAreas[index].areaLabel));
                      },
                    ), onChanged: (v){
                      selectLangArea(v!);
                    }),
                  )
                ],
              )
            ],
          ),
        ))
      ],
    );
  }

  selectLangLocale(LangLocale langLocale){
    setState(() {
      _selectedLangLocale = langLocale;
      _langAreas = langLocalesMap[langLocale.langCode]!.langAreas;
      _selectedLangArea = _langAreas[0];
    });
  }

  selectLangArea(LangArea langArea){
    setState(() {
      _selectedLangArea = langArea;
    });
  }

}
