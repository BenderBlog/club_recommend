import 'package:flutter/material.dart';

class ReloadWidget extends StatelessWidget {
  final void Function() function;
  // Stands for Exception...
  final Object? errorStatus;
  final String? buttonName;
  const ReloadWidget({
    super.key,
    required this.function,
    this.buttonName,
    this.errorStatus,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 600),
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "加载遇到错误\n"
                "${errorStatus != null ? errorStatus.toString() : ""}",
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              FilledButton(onPressed: function, child: Text("重新加载")),
            ],
          ),
        ),
      ),
    );
  }
}
