// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String hello(String userName) {
    return 'Hello $userName.';
  }

  @override
  String get fsFavoriteTitle => 'Favorites';

  @override
  String get addFavoriteTitle => 'Add Favorite （You can rename it to alias)';

  @override
  String get addFavoriteNameAlias => 'Favorite Name Alias';

  @override
  String get fsDiskTitle => 'Disk';

  @override
  String get fsMyComputerTitle => 'This machine';

  @override
  String get fsEntitiesTableHeaderName => 'Name';

  @override
  String get fsEntitiesTableHeaderDate => 'Date';

  @override
  String get fsEntitiesTableHeaderType => 'Type';

  @override
  String get tabLabelBlank => 'New Tab';

  @override
  String get contextMenuAddFavorite => 'Add Favorite';

  @override
  String get contextMenuCopy => 'Copy';

  @override
  String get contextMenuCut => 'Cut';

  @override
  String get contextMenuPaste => 'Paste';

  @override
  String get contextMenuAddToSandbarFs => 'Add To SandbarFS';

  @override
  String get contextMenuDelete => 'Delete';

  @override
  String get contextMenuRename => 'Rename';

  @override
  String get contextMenuNewFolder => 'New folder';

  @override
  String get cancelLabel => 'Cancel';

  @override
  String get okLabel => 'OK';

  @override
  String get taskListTitleLabel => 'Tasks';

  @override
  String get taskStatusWaiting => 'Waiting';

  @override
  String get taskStatusRunning => 'Running';

  @override
  String get taskStatusPaused => 'Paused';

  @override
  String get taskStatusDone => 'Done';

  @override
  String get taskStatusFailed => 'Failed';

  @override
  String get taskStatusTerminated => 'Cancelled';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsPreferences => 'Preferences';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageLanguageCode => '语言';

  @override
  String get settingsLanguageCountryCode => '区域';

  @override
  String get settingsConfigurationSaveLocation => 'Configuration Save Location';

  @override
  String get settingsFileDirectoryOptions => 'File & Directory Options';

  @override
  String get settingsKeymap => 'Keymap';

  @override
  String get settingsExtensions => 'Extensions';

  @override
  String get settingsAdvancedSettings => 'Advanced Settings';

  @override
  String get settingsAdvancedSandbarClientNodeConfig => 'Sandbar Client';

  @override
  String get settingsAdvancedSandbarClientDataLocation => 'Data Location';

  @override
  String get settingsAdvancedSandbarClientRunningStatus => 'Status';

  @override
  String get settingsAdvancedSandbarClientRunningStatusIng => 'Running';

  @override
  String get settingsAdvancedSandbarClientRunningStatusStopped => 'Stopped';

  @override
  String get settingsAdvancedSandbarClientStartService => 'Start';

  @override
  String get settingsAdvancedSandbarClientStopService => 'Stop';

  @override
  String get settingsAccountSettings => 'Account Settings';

  @override
  String get settingsOk => 'OK';

  @override
  String get settingsCancel => 'Cancel';

  @override
  String get settingsApply => 'Apply';

  @override
  String get settingsSbcApiHostLabel => 'Sbc Api Host';

  @override
  String get loggedInLabel => 'Logged In';

  @override
  String get loginButtonLabel => 'Login';

  @override
  String get registerButtonLabel => 'Register';

  @override
  String get registerFormLabel => 'Register';

  @override
  String get registerFormEmailLabel => 'Email';

  @override
  String get registerFormPasswordLabel => 'Password';

  @override
  String get registerFormSubmitLabel => 'Register';

  @override
  String get loginFormLabel => 'Login';

  @override
  String get loginFormEmailLabel => 'Email';

  @override
  String get loginFormPasswordLabel => 'Password';

  @override
  String get loginFormSubmitLabel => 'Login';

  @override
  String get logoutLabel => 'Logout';

  @override
  String get markdownEditLabel => 'Edit';

  @override
  String get markdownPreviewLabel => 'Preview';

  @override
  String get markdownDataEmptyText => 'No contents';

  @override
  String get markdownNewCollectButtonLabel => 'Create new collection';

  @override
  String get markdownNewSubCollectButtonLabel => 'Create sub collection';

  @override
  String get markdownNewDocumentButtonLabel => 'Create new document';

  @override
  String get sbcDevicesNumLabel => 'Registered devices num';

  @override
  String get sbcDevicesViewLabel => 'View all devices';

  @override
  String get sbcDevicesHideLabel => 'Hide devices list';

  @override
  String get sbcCurrentDeviceLabel => 'Current';

  @override
  String get sbcCurrentDeviceUnregistered => 'Unregistered';

  @override
  String get sbcRegisterNewDeviceLabel => 'Register new device';

  @override
  String get sandbarClientNodeDataLocation => 'Data Location';

  @override
  String get sandbarClientNodeConfigPath => 'Config File';

  @override
  String get sandbarClientNodeCreate => 'Create';

  @override
  String get sandbarClientNodeNotExists => 'Instance not exists';
}
