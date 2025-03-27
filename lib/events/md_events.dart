import 'package:llfile/models/markdown_model.dart';
import 'package:llfile/widgets/partials/ll_md_widget.dart';

class OpenMdObjectEvent {
  final MdObject mdObject;

  OpenMdObjectEvent({required this.mdObject});
}


class SwitchMdObjectOperateTypeEvent {
  final MdObject mdObject;
  final LlMdOperateType llMdOperateType;

  SwitchMdObjectOperateTypeEvent({required this.mdObject, required this.llMdOperateType});
}