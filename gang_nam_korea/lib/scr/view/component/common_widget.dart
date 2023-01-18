import 'package:flutter/material.dart';

class CommonWidget {
  static showConfirmDialog(
    BuildContext context, {
    String? title,
    String? content,
    VoidCallback? onPressed1,
    VoidCallback? onPressed2,
    String? actionText1,
    String? actionText2,
  }) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
              title: title == null ? null : Text(title),
              content: content == null
                  ? null
                  : SingleChildScrollView(
                      child: ListBody(
                        children: [Text(content)],
                      ),
                    ),
              actions: [
                TextButton(
                    onPressed: () {
                      if (onPressed1 != null) onPressed1();
                      Navigator.pop(context);
                    },
                    child: Text(actionText1 ?? '취소')),
                TextButton(
                    onPressed: () {
                      if (onPressed2 != null) onPressed2();
                      Navigator.pop(context);
                    },
                    child: Text(actionText2 ?? '확인')),
              ]);
        });
  }

  static showNoticeDialog(
    BuildContext context, {
    String? title,
    String? content,
    VoidCallback? onPressed,
    String? actionText,
  }) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
              title: title == null ? null : Text(title),
              content: content == null
                  ? null
                  : SingleChildScrollView(
                      child: ListBody(
                        children: [Text(content)],
                      ),
                    ),
              actions: [
                TextButton(
                    onPressed: () {
                      if (onPressed != null) onPressed();
                      Navigator.pop(context);
                    },
                    child: Text(actionText ?? '확인')),
              ]);
        });
  }
}
