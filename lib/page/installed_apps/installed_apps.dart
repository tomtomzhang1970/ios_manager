import 'dart:io';
import 'dart:ui';

import 'package:device_apps/device_apps.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lan_express/common/widget/action_button.dart';
import 'package:lan_express/common/widget/function_widget.dart';
import 'package:lan_express/common/widget/no_resize_text.dart';
import 'package:lan_express/common/widget/show_modal.dart';
import 'package:lan_express/page/file_manager/file_action.dart';
import 'package:lan_express/page/file_manager/file_item.dart';
import 'package:lan_express/provider/share.dart';
import 'package:lan_express/provider/theme.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as pathLib;
import 'package:intent/action.dart' as action;
import 'package:intent/intent.dart' as intent;

class InstalledAppsPage extends StatefulWidget {
  @override
  _InstalledAppsPageState createState() => _InstalledAppsPageState();
}

class _InstalledAppsPageState extends State<InstalledAppsPage> {
  ThemeProvider _themeProvider;
  ShareProvider _shareProvider;
  bool _showSystemApps = false;
  List<Application> apps = [];
  bool locker = true;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _themeProvider = Provider.of<ThemeProvider>(context);
    _shareProvider = Provider.of<ShareProvider>(context);
    if (locker) {
      locker = false;
      apps = await DeviceApps.getInstalledApplications(
        includeAppIcons: true,
        includeSystemApps: _showSystemApps,
        onlyAppsWithLaunchIntent: false,
      );
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    apps = null;
  }

  @override
  Widget build(BuildContext context) {
    dynamic themeData = _themeProvider.themeData;

    return Material(
      child: CupertinoPageScaffold(
        backgroundColor: themeData?.scaffoldBackgroundColor,
        navigationBar: CupertinoNavigationBar(
          backgroundColor: themeData?.navBackgroundColor,
          middle: NoResizeText(
            '本机应用',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 20,
              color: themeData?.navTitleColor,
            ),
          ),
          trailing: InkWell(
            onTap: () async {
              apps = null;
              if (mounted) {
                setState(() {
                  apps = [];
                  _showSystemApps = !_showSystemApps;
                });
                apps = await DeviceApps.getInstalledApplications(
                  includeAppIcons: true,
                  includeSystemApps: _showSystemApps,
                  onlyAppsWithLaunchIntent: false,
                );
                if (mounted) { 
                  setState(() {});
                }
              }
            },
            child: NoResizeText(
              _showSystemApps ? '普通应用' : '系统应用',
              style: TextStyle(
                color: Color(0xFF007AFF),
              ),
            ),
          ),
          border: null,
          automaticallyImplyLeading: false,
        ),
        child: apps.isEmpty
            ? Center(child: loadingIndicator(context, _themeProvider))
            : Scrollbar(
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    Application app = apps[index];
                    File file = File(app.apkFilePath);
                    String ext = pathLib.extension(app.apkFilePath);
                    SelfFileEntity fileEntity = SelfFileEntity(
                      modified: file.statSync().modified,
                      entity: file,
                      filename: '${app.appName} (${app.packageName})',
                      ext: ext,
                      apkIcon: app is ApplicationWithIcon ? app.icon : null,
                      isDir: file.statSync().type ==
                          FileSystemEntityType.directory,
                      modeString: null,
                      type: null,
                    );

                    return Column(
                      children: <Widget>[
                        FileItem(
                          type: FileItemType.file,
                          leading: app is ApplicationWithIcon
                              ? CircleAvatar(
                                  backgroundImage: MemoryImage(app.icon),
                                  backgroundColor: Colors.white,
                                )
                              : null,
                          withAnimation: index < 15,
                          index: index,
                          subTitle: '\n版本: ${app.versionName}\n'
                              '系统应用: ${app.systemApp}\n'
                              'APK 位置: ${app.apkFilePath}\n'
                              '数据目录: ${app.dataDir}\n'
                              '安装时间: ${DateTime.fromMillisecondsSinceEpoch(app.installTimeMillis).toString()}\n'
                              '更新时间: ${DateTime.fromMillisecondsSinceEpoch(app.updateTimeMillis).toString()}\n',
                          onLongPress: (details) async {
                            showCupertinoModal(
                              filter:
                                  ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (context, changeState) {
                                    return SplitSelectionModal(
                                      rightChildren: <Widget>[
                                        ActionButton(
                                          content: '卸载',
                                          onTap: () async {
                                            await showTipTextModal(
                                                context, _themeProvider,
                                                title: '卸载',
                                                tip: '确定卸载${app.packageName}',
                                                onOk: () {
                                              intent.Intent()
                                                ..setAction(
                                                    action.Action.ACTION_DELETE)
                                                ..setData(Uri.parse(
                                                    "package:${app.packageName}"))
                                                ..startActivityForResult().then(
                                                  (data) {
                                                    print(data);
                                                  },
                                                  onError: (e) {
                                                    FLog.error(text: '$e');
                                                  },
                                                );
                                            }, onCancel: () {});
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                          onTap: () {
                            DeviceApps.openApp(app.packageName);
                          },
                          subTitleSize: 12,
                          titleSize: 16,
                          autoWrap: false,
                          path: app.apkFilePath,
                          filename: '${app.appName} (${app.packageName})',
                          onHozDrag: (dir) async {
                            if (await file.exists()) {
                              if (dir == 1) {
                                _shareProvider.addFile(fileEntity);
                              } else if (dir == -1) {
                                _shareProvider.removeFile(fileEntity);
                              }
                            }
                          },
                        ),
                        // ),
                      ],
                    );
                  },
                  itemCount: apps.length,
                ),
              ),
      ),
    );
  }
}