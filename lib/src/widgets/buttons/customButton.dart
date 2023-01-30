


import 'package:productos_app/src/ui/pages/pages.dart';

class CustomButtom extends StatelessWidget {
  const CustomButtom({
    super.key,
    required this.onClick,
    this.borderRadius,
    this.width,
    this.height,
    required this.text,
    this.textColor,
    this.backgroundColor
  });


  final Function onClick;
  final double? borderRadius;
  final double? width;
  final double? height;
  final String text;
  final Color? textColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ??  0.0)
      ),
      onPressed: () => onClick(),
      color:  backgroundColor ?? Colors.indigo.shade200,
      disabledColor: Colors.grey.shade500,
      minWidth: width != null ? width! * 10 : 0,
      height: height,
      child: Text(text,style: TextStyle(
          color: textColor ??  Colors.black
        ),
      ),
    );
  }
}