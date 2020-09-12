import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lan_express/common/widget/no_resize_text.dart';
import 'package:lan_express/common/widget/point_tab.dart';
import 'package:lan_express/page/lan/share.dart';
import 'package:lan_express/provider/theme.dart';
import 'package:provider/provider.dart';

// import 'package:sqflite_sqlcipher/sqflite.dart';

class LanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LanPageState();
  }
}

class LanPageState extends State<LanPage> {
  ThemeProvider _themeProvider;
  TabController _controller;

  List<Tab> _tabs;

  @override
  void initState() {
    super.initState();

    _tabs = [
      Tab(child: LanText('传输', alignX: 0)),
      // Tab(child: LanText('剪贴板', alignX: 0)),
      Tab(child: LanText('控制', alignX: 0)),
    ];
    _controller = TabController(
      length: _tabs.length,
      vsync: ScrollableState(),
    );
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _themeProvider = Provider.of<ThemeProvider>(context);

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic themeData = _themeProvider?.themeData;

    return Material(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: TabBar(
            tabs: _tabs,
            controller: _controller,
            indicatorPadding: EdgeInsets.all(0),
            isScrollable: true,
            indicator: PointTabIndicator(
              position: PointTabIndicatorPosition.bottom,
              color: Color(0xFF007AFF),
              insets: EdgeInsets.only(bottom: 3),
            ),
          ),
          backgroundColor: themeData?.navBackgroundColor,
          border: null,
        ),
        child: SafeArea(
          child: TabBarView(
            controller: _controller,
            children: <Widget>[
              StaticSharePage(),
              Container(
                child: Center(
                    child: LanText(
                  '远程控制, 远程游戏手柄, 敬请期待',
                  alignX: 0,
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}