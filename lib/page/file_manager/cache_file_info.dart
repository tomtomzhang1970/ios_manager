import 'package:flutter/cupertino.dart';

class CacheFileInfo {
  final String path;
  final String modified;
  final String size;
  final Widget leading;
  final String filename;

  CacheFileInfo({
    this.filename,
    this.path,
    this.modified,
    this.size,
    this.leading,
  });
}
