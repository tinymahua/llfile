import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'i10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// A message with a single parameter
  ///
  /// In en, this message translates to:
  /// **'Hello {userName}.'**
  String hello(String userName);

  /// No description provided for @fsFavoriteTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get fsFavoriteTitle;

  /// No description provided for @addFavoriteTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Favorite （You can rename it to alias)'**
  String get addFavoriteTitle;

  /// No description provided for @addFavoriteNameAlias.
  ///
  /// In en, this message translates to:
  /// **'Favorite Name Alias'**
  String get addFavoriteNameAlias;

  /// No description provided for @fsDiskTitle.
  ///
  /// In en, this message translates to:
  /// **'Disk'**
  String get fsDiskTitle;

  /// No description provided for @fsMyComputerTitle.
  ///
  /// In en, this message translates to:
  /// **'This machine'**
  String get fsMyComputerTitle;

  /// No description provided for @fsEntitiesTableHeaderName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fsEntitiesTableHeaderName;

  /// No description provided for @fsEntitiesTableHeaderDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get fsEntitiesTableHeaderDate;

  /// No description provided for @fsEntitiesTableHeaderType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get fsEntitiesTableHeaderType;

  /// No description provided for @tabLabelBlank.
  ///
  /// In en, this message translates to:
  /// **'New Tab'**
  String get tabLabelBlank;

  /// No description provided for @contextMenuAddFavorite.
  ///
  /// In en, this message translates to:
  /// **'Add Favorite'**
  String get contextMenuAddFavorite;

  /// No description provided for @contextMenuCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get contextMenuCopy;

  /// No description provided for @contextMenuCut.
  ///
  /// In en, this message translates to:
  /// **'Cut'**
  String get contextMenuCut;

  /// No description provided for @contextMenuPaste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get contextMenuPaste;

  /// No description provided for @contextMenuAddToSandbarFs.
  ///
  /// In en, this message translates to:
  /// **'Add To SandbarFS'**
  String get contextMenuAddToSandbarFs;

  /// No description provided for @contextMenuDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get contextMenuDelete;

  /// No description provided for @contextMenuRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get contextMenuRename;

  /// No description provided for @contextMenuNewFolder.
  ///
  /// In en, this message translates to:
  /// **'New folder'**
  String get contextMenuNewFolder;

  /// No description provided for @cancelLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelLabel;

  /// No description provided for @okLabel.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okLabel;

  /// No description provided for @taskListTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get taskListTitleLabel;

  /// No description provided for @taskStatusWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get taskStatusWaiting;

  /// No description provided for @taskStatusRunning.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get taskStatusRunning;

  /// No description provided for @taskStatusPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get taskStatusPaused;

  /// No description provided for @taskStatusDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get taskStatusDone;

  /// No description provided for @taskStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get taskStatusFailed;

  /// No description provided for @taskStatusTerminated.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get taskStatusTerminated;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get settingsPreferences;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageLanguageCode.
  ///
  /// In en, this message translates to:
  /// **'语言'**
  String get settingsLanguageLanguageCode;

  /// No description provided for @settingsLanguageCountryCode.
  ///
  /// In en, this message translates to:
  /// **'区域'**
  String get settingsLanguageCountryCode;

  /// No description provided for @settingsConfigurationSaveLocation.
  ///
  /// In en, this message translates to:
  /// **'Configuration Save Location'**
  String get settingsConfigurationSaveLocation;

  /// No description provided for @settingsFileDirectoryOptions.
  ///
  /// In en, this message translates to:
  /// **'File & Directory Options'**
  String get settingsFileDirectoryOptions;

  /// No description provided for @settingsKeymap.
  ///
  /// In en, this message translates to:
  /// **'Keymap'**
  String get settingsKeymap;

  /// No description provided for @settingsExtensions.
  ///
  /// In en, this message translates to:
  /// **'Extensions'**
  String get settingsExtensions;

  /// No description provided for @settingsAdvancedSettings.
  ///
  /// In en, this message translates to:
  /// **'Advanced Settings'**
  String get settingsAdvancedSettings;

  /// No description provided for @settingsAdvancedSandbarClientNodeConfig.
  ///
  /// In en, this message translates to:
  /// **'Sandbar Client'**
  String get settingsAdvancedSandbarClientNodeConfig;

  /// No description provided for @settingsAdvancedSandbarClientDataLocation.
  ///
  /// In en, this message translates to:
  /// **'Data Location'**
  String get settingsAdvancedSandbarClientDataLocation;

  /// No description provided for @settingsAdvancedSandbarClientRunningStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get settingsAdvancedSandbarClientRunningStatus;

  /// No description provided for @settingsAdvancedSandbarClientRunningStatusIng.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get settingsAdvancedSandbarClientRunningStatusIng;

  /// No description provided for @settingsAdvancedSandbarClientRunningStatusStopped.
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get settingsAdvancedSandbarClientRunningStatusStopped;

  /// No description provided for @settingsAdvancedSandbarClientStartService.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get settingsAdvancedSandbarClientStartService;

  /// No description provided for @settingsAdvancedSandbarClientStopService.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get settingsAdvancedSandbarClientStopService;

  /// No description provided for @settingsAccountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get settingsAccountSettings;

  /// No description provided for @settingsOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get settingsOk;

  /// No description provided for @settingsCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settingsCancel;

  /// No description provided for @settingsApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get settingsApply;

  /// No description provided for @settingsSbcApiHostLabel.
  ///
  /// In en, this message translates to:
  /// **'Sbc Api Host'**
  String get settingsSbcApiHostLabel;

  /// No description provided for @loggedInLabel.
  ///
  /// In en, this message translates to:
  /// **'Logged In'**
  String get loggedInLabel;

  /// No description provided for @loginButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButtonLabel;

  /// No description provided for @registerButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerButtonLabel;

  /// No description provided for @registerFormLabel.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerFormLabel;

  /// No description provided for @registerFormEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get registerFormEmailLabel;

  /// No description provided for @registerFormPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get registerFormPasswordLabel;

  /// No description provided for @registerFormSubmitLabel.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerFormSubmitLabel;

  /// No description provided for @loginFormLabel.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginFormLabel;

  /// No description provided for @loginFormEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginFormEmailLabel;

  /// No description provided for @loginFormPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginFormPasswordLabel;

  /// No description provided for @loginFormSubmitLabel.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginFormSubmitLabel;

  /// No description provided for @logoutLabel.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutLabel;

  /// No description provided for @markdownEditLabel.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get markdownEditLabel;

  /// No description provided for @markdownPreviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get markdownPreviewLabel;

  /// No description provided for @markdownDataEmptyText.
  ///
  /// In en, this message translates to:
  /// **'No contents'**
  String get markdownDataEmptyText;

  /// No description provided for @markdownNewCollectButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Create new collection'**
  String get markdownNewCollectButtonLabel;

  /// No description provided for @markdownNewSubCollectButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Create sub collection'**
  String get markdownNewSubCollectButtonLabel;

  /// No description provided for @markdownNewDocumentButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Create new document'**
  String get markdownNewDocumentButtonLabel;

  /// No description provided for @sbcDevicesNumLabel.
  ///
  /// In en, this message translates to:
  /// **'Registered devices num'**
  String get sbcDevicesNumLabel;

  /// No description provided for @sbcDevicesViewLabel.
  ///
  /// In en, this message translates to:
  /// **'View all devices'**
  String get sbcDevicesViewLabel;

  /// No description provided for @sbcDevicesHideLabel.
  ///
  /// In en, this message translates to:
  /// **'Hide devices list'**
  String get sbcDevicesHideLabel;

  /// No description provided for @sbcCurrentDeviceLabel.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get sbcCurrentDeviceLabel;

  /// No description provided for @sbcCurrentDeviceUnregistered.
  ///
  /// In en, this message translates to:
  /// **'Unregistered'**
  String get sbcCurrentDeviceUnregistered;

  /// No description provided for @sbcRegisterNewDeviceLabel.
  ///
  /// In en, this message translates to:
  /// **'Register new device'**
  String get sbcRegisterNewDeviceLabel;

  /// No description provided for @sandbarClientNodeDataLocation.
  ///
  /// In en, this message translates to:
  /// **'Data Location'**
  String get sandbarClientNodeDataLocation;

  /// No description provided for @sandbarClientNodeConfigPath.
  ///
  /// In en, this message translates to:
  /// **'Config File'**
  String get sandbarClientNodeConfigPath;

  /// No description provided for @sandbarClientNodeCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get sandbarClientNodeCreate;

  /// No description provided for @sandbarClientNodeNotExists.
  ///
  /// In en, this message translates to:
  /// **'Instance not exists'**
  String get sandbarClientNodeNotExists;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
