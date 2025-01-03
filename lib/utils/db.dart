import 'dart:convert';
import 'dart:io';

import 'package:llfile/models/app_states_model.dart';
import 'package:llfile/models/operate_record_model.dart';
import 'package:llfile/models/path_model.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


abstract class Db {
  Db._(this.dbName);

  String dbName;

  Future<String> getDbPath()async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final docDir = await getApplicationDocumentsDirectory();
    var dbPath = join(docDir.path, packageInfo.appName, dbName);
    return dbPath;
  }

  Future<M> read<M>()async{
    var file = File(await getDbPath());

    if (!file.parent.existsSync()){
      file.parent.createSync(recursive: true);
    }

    if (!file.existsSync()){
      await initDb();
      file = File(await getDbPath());
    }

    var content = await file.readAsString();
    Map<String, dynamic> json = jsonDecode(content);
    return deserialize(json);
  }

  write<M>(M value)async{
    Map<String, dynamic> json = serialize(value);
    var file = File(await getDbPath());
    await file.writeAsString(jsonEncode(json));
  }

  // This method must be override
  Future<String> initDb(){
    throw UnimplementedError();
  }

  dynamic deserialize(Map<String, dynamic> json){
    throw UnimplementedError();
  }

  dynamic serialize(dynamic value){
    throw UnimplementedError();
  }
}

class PathHistoryDb extends Db {
  static const String _dbName = "history.json";

  PathHistoryDb() : super._(_dbName);

  @override
  Future<String> initDb() async{
    var dbPath = await getDbPath();

    if (!File(dbPath).existsSync()){
      await File(dbPath).create(recursive: true);
      write(PathHistories([]));
    }

    return dbPath;
  }

  @override
  PathHistories deserialize(Map<String, dynamic> json) {
    return PathHistories.fromJson(json);
  }

  @override
  Map<String, dynamic> serialize(dynamic value) {
    return value.toJson();
  }

  Future<String> addHistory(String path)async{
    var pathHistories = await read<PathHistories>();
    pathHistories.histories.add(path);
    await write(pathHistories);
    return path;
  }
}


class AppStatesMemDb {
  int activatedFileBrowserTabIdx = 0;

  OperateRecord? copyOrCutOperateRecord;

  AppStatesMemDb();
}
