import 'dart:io';

import 'package:flutter/material.dart';

enum ToolboxItemType {
  image,
  video,
  audio,
  document,
  archive,
  directory,
  unknown,
}

class ToolboxItem {
  final String path;
  final bool isDir;
  final ToolboxItemType type;
  final int size; // bytes, 0 for directory
  final String name;

  ToolboxItem({
    required this.path,
    required this.isDir,
    required this.type,
    required this.size,
    required this.name,
  });

  static ToolboxItem fromPath(String path) {
    final entityType = FileSystemEntity.typeSync(path);
    final isDir = entityType == FileSystemEntityType.directory;
    int size = 0;
    if (!isDir) {
      try {
        size = File(path).lengthSync();
      } catch (_) {
        size = 0;
      }
    }
    final name = path.split(Platform.pathSeparator).last;
    final type = isDir ? ToolboxItemType.directory : _typeFromExtension(path);
    return ToolboxItem(
      path: path,
      isDir: isDir,
      type: type,
      size: size,
      name: name,
    );
  }

  static ToolboxItemType _typeFromExtension(String path) {
    final ext = path.contains('.')
        ? path.split('.').last.toLowerCase()
        : '';
    if (_imageExts.contains(ext)) return ToolboxItemType.image;
    if (_videoExts.contains(ext)) return ToolboxItemType.video;
    if (_audioExts.contains(ext)) return ToolboxItemType.audio;
    if (_docExts.contains(ext)) return ToolboxItemType.document;
    if (_archiveExts.contains(ext)) return ToolboxItemType.archive;
    return ToolboxItemType.unknown;
  }

  IconData get icon {
    switch (type) {
      case ToolboxItemType.image:
        return Icons.image;
      case ToolboxItemType.video:
        return Icons.movie;
      case ToolboxItemType.audio:
        return Icons.audiotrack;
      case ToolboxItemType.document:
        return Icons.description;
      case ToolboxItemType.archive:
        return Icons.folder_zip;
      case ToolboxItemType.directory:
        return Icons.folder;
      case ToolboxItemType.unknown:
        return Icons.insert_drive_file;
    }
  }

  String get typeLabel {
    switch (type) {
      case ToolboxItemType.image:
        return '图片';
      case ToolboxItemType.video:
        return '视频';
      case ToolboxItemType.audio:
        return '音频';
      case ToolboxItemType.document:
        return '文档';
      case ToolboxItemType.archive:
        return '压缩包';
      case ToolboxItemType.directory:
        return '目录';
      case ToolboxItemType.unknown:
        return '未知';
    }
  }

  String get sizeLabel {
    if (isDir) return '—';
    return _formatSize(size);
  }

  static String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / 1024 / 1024).toStringAsFixed(1)} MB';
    }
    return '${(bytes / 1024 / 1024 / 1024).toStringAsFixed(1)} GB';
  }
}

const _imageExts = {
  'png',
  'jpg',
  'jpeg',
  'gif',
  'bmp',
  'webp',
  'heic',
  'tiff',
  'svg',
};

const _videoExts = {
  'mp4',
  'mov',
  'avi',
  'mkv',
  'webm',
  'flv',
  'wmv',
  'm4v',
};

const _audioExts = {
  'mp3',
  'wav',
  'flac',
  'aac',
  'ogg',
  'm4a',
  'wma',
};

const _docExts = {
  'txt',
  'md',
  'pdf',
  'doc',
  'docx',
  'xls',
  'xlsx',
  'ppt',
  'pptx',
  'json',
  'yaml',
  'yml',
  'csv',
  'html',
  'htm',
  'rtf',
  'epub',
};

const _archiveExts = {
  'zip',
  'rar',
  '7z',
  'tar',
  'gz',
  'tgz',
  'bz2',
  'xz',
};
