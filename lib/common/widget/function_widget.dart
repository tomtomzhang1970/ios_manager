import 'package:flutter/cupertino.dart';
import 'package:lan_express/common/widget/no_resize_text.dart';
import 'package:lan_express/provider/theme.dart';

Widget loadingIndicator(BuildContext context, ThemeProvider provider) =>
    CupertinoTheme(
      data: CupertinoTheme.of(context).copyWith(
          brightness: provider.isDark ? Brightness.dark : Brightness.light),
      child: CupertinoActivityIndicator(),
    );

Widget loadingWithText(BuildContext context, ThemeProvider provider,
        {@required String text}) =>
    Column(
      children: <Widget>[
        loadingIndicator(context, provider),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width - 100,
          child: NoResizeText(
            text,
            overflow: TextOverflow.ellipsis,
            // style:  TextStyle(),
          ),
        ),
      ],
    );

Widget blockTitle(String title, {String subtitle}) => Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        NoResizeText(
          title,
          style: TextStyle(fontSize: 18, color: Color(0xFF007AFF)),
        ),
        SizedBox(width: 5),
        if (subtitle != null) LanText(subtitle, small: true)
      ]),
    );
