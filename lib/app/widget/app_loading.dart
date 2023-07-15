
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void loading({RxString? loadingText, Function()? onCancel}) async {
  await Get.dialog(
    CupertinoAlertDialog(
      content: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/loading.gif',
            width: 30,
            height: 30,
            cacheWidth: 30,
            cacheHeight: 30,
          ),
          const SizedBox(
            width: 24,
          ),
          if (loadingText != null)
            Obx(() =>
                Text(loadingText.value, style: const TextStyle(fontSize: 16))),
        ],
      ),
      actions: [
        if (onCancel != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(onPressed: onCancel, child: const Text('Cancel')),
          )
      ],
    ),
  );
}

void cautionDialog(String? content,
    {bool center = true,
    bool dismissable = false,
    String? title,
    Function()? onDismiss}) async {
  await Get.dialog(
    CupertinoAlertDialog(
      title: Text(
        title ?? "Caution!",
      ),
      content: Text(
        content ?? 'Unknown error',
        textAlign: center ? TextAlign.center : TextAlign.left,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            if (onDismiss != null) onDismiss();
          },
          child: const Text(
            "OK",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    ),
    barrierDismissible: dismissable,
  );
}