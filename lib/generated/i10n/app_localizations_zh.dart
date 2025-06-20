// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String hello(String userName) {
    return '你好， $userName。';
  }

  @override
  String get fsFavoriteTitle => '收藏夹';

  @override
  String get addFavoriteTitle => '添加收藏夹（可指定新的别名）';

  @override
  String get addFavoriteNameAlias => '收藏夹别名';

  @override
  String get fsDiskTitle => '本地磁盘';

  @override
  String get fsMyComputerTitle => '此电脑';

  @override
  String get fsEntitiesTableHeaderName => '名称';

  @override
  String get fsEntitiesTableHeaderDate => '日期';

  @override
  String get fsEntitiesTableHeaderType => '类型';

  @override
  String get tabLabelBlank => '新标签';

  @override
  String get contextMenuAddFavorite => '添加到快速访问';

  @override
  String get contextMenuCopy => '复制';

  @override
  String get contextMenuCut => '剪切';

  @override
  String get contextMenuPaste => '粘贴';

  @override
  String get contextMenuAddToSandbarFs => '添加到沙洲';

  @override
  String get contextMenuDelete => '删除';

  @override
  String get contextMenuRename => '重命名';

  @override
  String get contextMenuNewFolder => '新建文件夹';

  @override
  String get cancelLabel => '取消';

  @override
  String get okLabel => '确定';

  @override
  String get taskListTitleLabel => '任务';

  @override
  String get taskStatusWaiting => '等待';

  @override
  String get taskStatusRunning => '正在处理';

  @override
  String get taskStatusPaused => '已暂停';

  @override
  String get taskStatusDone => '已完成';

  @override
  String get taskStatusFailed => '已失败';

  @override
  String get taskStatusTerminated => '已取消';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsPreferences => '个人偏好';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsLanguageLanguageCode => 'Language';

  @override
  String get settingsLanguageCountryCode => 'Area';

  @override
  String get settingsConfigurationSaveLocation => '配置保存位置';

  @override
  String get settingsFileDirectoryOptions => '文件目录选项';

  @override
  String get settingsKeymap => '快捷键';

  @override
  String get settingsExtensions => '扩展';

  @override
  String get settingsAdvancedSettings => '高级设置';

  @override
  String get settingsAdvancedSandbarClientNodeConfig => '沙洲客户端';

  @override
  String get settingsAdvancedSandbarClientDataLocation => '数据位置';

  @override
  String get settingsAdvancedSandbarClientRunningStatus => '状态';

  @override
  String get settingsAdvancedSandbarClientRunningStatusIng => '运行中';

  @override
  String get settingsAdvancedSandbarClientRunningStatusStopped => '未运行';

  @override
  String get settingsAdvancedSandbarClientStartService => '启动';

  @override
  String get settingsAdvancedSandbarClientStopService => '停止';

  @override
  String get settingsAccountSettings => '账户';

  @override
  String get settingsOk => '确定';

  @override
  String get settingsCancel => '取消';

  @override
  String get settingsApply => '应用';

  @override
  String get settingsSbcApiHostLabel => 'Sbc API 地址';

  @override
  String get loggedInLabel => '已登录';

  @override
  String get loginButtonLabel => '登录';

  @override
  String get registerButtonLabel => '注册';

  @override
  String get registerFormLabel => '注册';

  @override
  String get registerFormEmailLabel => '邮箱';

  @override
  String get registerFormPasswordLabel => '密码';

  @override
  String get registerFormSubmitLabel => '注册';

  @override
  String get loginFormLabel => '登录';

  @override
  String get loginFormEmailLabel => '邮箱';

  @override
  String get loginFormPasswordLabel => '密码';

  @override
  String get loginFormSubmitLabel => '登录';

  @override
  String get logoutLabel => '退出登录';

  @override
  String get markdownEditLabel => '编辑';

  @override
  String get markdownPreviewLabel => '预览';

  @override
  String get markdownDataEmptyText => '无内容';

  @override
  String get markdownNewCollectButtonLabel => '创建新集合';

  @override
  String get markdownNewSubCollectButtonLabel => '创建子集合';

  @override
  String get markdownNewDocumentButtonLabel => '创建新文档';

  @override
  String get sbcDevicesNumLabel => '已注册设备数量';

  @override
  String get sbcDevicesViewLabel => '查看所有设备';

  @override
  String get sbcDevicesHideLabel => '隐藏设备列表';

  @override
  String get sbcCurrentDeviceLabel => '本设备';

  @override
  String get sbcCurrentDeviceUnregistered => '未注册';

  @override
  String get sbcRegisterNewDeviceLabel => '注册新设备';

  @override
  String get sandbarClientNodeDataLocation => '数据位置';

  @override
  String get sandbarClientNodeConfigPath => '配置文件';

  @override
  String get sandbarClientNodeCreate => '创建';

  @override
  String get sandbarClientNodeNotExists => '实例未创建';
}
