import '/libraries/system_packages.dart';

class CustomButton extends StatefulWidget {
  final Color? color;
  final VoidCallback? onPressed;
  final Widget widget;

  const CustomButton({
    super.key,
    this.color,
    required this.onPressed,
    required this.widget,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: Container(
        alignment: AlignmentDirectional.center,
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
          color: widget.color ?? const Color.fromARGB(255, 64, 101, 252),
          borderRadius: BorderRadius.circular(20),
          boxShadow: _isPressed ? []
          : [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 4)
            )
          ]
        ),
        child: widget.widget
      )
    );
  }
}