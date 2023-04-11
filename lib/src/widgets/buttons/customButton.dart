// ignore_for_file: file_names

import 'package:productos_app/src/ui/pages/pages.dart';

class CustomButtom extends StatelessWidget {
  const CustomButtom({
    super.key,
    this.onClick,
    this.borderRadius,
    this.width,
    this.height,
    required this.text,
    this.textColor,
    this.backgroundColor,
    this.child,
  });


  final VoidCallback? onClick;
  final double? borderRadius;
  final double? width;
  final double? height;
  final String text;
  final Color? textColor;
  final Color? backgroundColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ??  0.0)
      ),
      onPressed: onClick,
      color:  backgroundColor ?? Colors.indigo.shade200,
      disabledColor: Colors.grey.shade500,
      minWidth: width != null ? width! * 10 : 0,
      height: height,
      child: child ?? Text(text,style: TextStyle(
          color: textColor ??  Colors.black
        ),
      ),
    );
  }
}