import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lan_file_more/common/widget/no_resize_text.dart';

class LanDialogTitle extends StatelessWidget {
  final String title;
  final String subTitle;

  const LanDialogTitle({Key key, this.title, this.subTitle = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        NoResizeText('$title'),
        SizedBox(width: 10),
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width / 2,
          ),
          child: NoResizeText(
            '$subTitle',
            style: TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class LanDialog extends Dialog {
  final Widget title;
  final List<Widget> children;
  final Color bgColor;
  final Color fontColor;
  final dynamic action;
  final Function onOk;
  final Function onCancel;
  final String defaultOkText;
  final String defaultCancelText;
  final MainAxisAlignment actionPos;
  final bool display;
  final bool withOk;
  final bool withCancel;

  LanDialog({
    this.display = false,
    this.actionPos = MainAxisAlignment.start,
    this.defaultOkText,
    this.defaultCancelText,
    this.title,
    this.action = true,
    @required this.fontColor,
    @required this.children,
    @required this.bgColor,
    this.onOk,
    this.onCancel,
    this.withOk = true,
    this.withCancel = true,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Offstage(
      offstage: display,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets +
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
            duration: insetAnimationDuration,
            curve: insetAnimationCurve,
            child: MediaQuery.removeViewInsets(
              removeLeft: true,
              removeTop: true,
              removeRight: true,
              removeBottom: true,
              context: context,
              child: Center(
                child: Wrap(
                  children: <Widget>[
                    Center(
                      child: Container(
                        width: screenWidth - 80,
                        child: Container(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 10,
                            bottom: 10,
                          ),
                          decoration: ShapeDecoration(
                            color: bgColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    if (title != null)
                                      DefaultTextStyle(
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: fontColor,
                                        ),
                                        child: title,
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15),
                              ...children,
                              if (action is List<Widget>) ...action,
                              if (!action) SizedBox(height: 30),
                              if (action)
                                Row(
                                  mainAxisAlignment: actionPos,
                                  children: <Widget>[
                                    if (withOk)
                                      CupertinoButton(
                                        child:
                                            NoResizeText(defaultOkText ?? '确定'),
                                        onPressed: onOk,
                                      ),
                                    if (withCancel)
                                      CupertinoButton(
                                        child: NoResizeText(
                                            defaultCancelText ?? '取消'),
                                        onPressed: onCancel,
                                      ),
                                  ],
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
