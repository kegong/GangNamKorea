import 'package:flutter/material.dart';

class CommonWidget {
  static Widget verticalDivider({Color color = const Color(0xFFEEEEEE), double width = 1, double height = 14}) {
    return Container(color: color, width: width, height: height);
  }

  static buildIsNew(DateTime? wdate) {
    if (wdate == null) {
      return const SizedBox(width: 15);
    }

    return wdate.difference(DateTime.now()).inDays >= 1
        ? const Text('ㆍ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red))
        : const SizedBox(width: 15);
  }

  static buildCircularProgress() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 12.0),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.grey[400]),
      ),
    );
  }

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
    VoidCallback? onPressedBackground,
    String? actionText,
  }) async {
    bool isClose = false;
    await showDialog(
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
                      isClose = true;
                      Navigator.pop(context);
                    },
                    child: Text(actionText ?? '확인')),
              ]);
        });

    if (isClose == false) {
      if (onPressedBackground != null) onPressedBackground();
    }
  }
}
