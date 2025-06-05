import '/libraries/system_packages.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final String? Function(String? value)? validator;
  final void Function(String value)? onChanged;
  final int? maxLenght;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final String? obscuringCharacter;
  final bool? obscureText;
  final FocusNode? focusNode;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  const CustomTextField({
    this.controller,
    this.textInputType,
    this.onChanged,
    this.validator,
    this.maxLenght,
    this.textAlign,
    this.textAlignVertical,
    this.focusNode,
    this.fontSize,
    this.fontWeight,
    this.obscuringCharacter,
    this.obscureText,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      onChanged: onChanged,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: isDark ? Colors.white : Colors.black
      ),
      maxLength: maxLenght,
      controller: controller,
      keyboardType: textInputType,
      textAlign: textAlign ?? TextAlign.start,
      textAlignVertical: textAlignVertical,
      focusNode: focusNode,
      validator: validator,
      obscuringCharacter: obscuringCharacter ?? '*',
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        errorMaxLines: 3,
        errorStyle: const TextStyle(
          color: Colors.red,
          shadows: []
        ),
        filled: true,
        fillColor: isDark ? const Color.fromARGB(255, 60, 60, 60) : const Color.fromARGB(255, 235, 235, 235),
        counterText: '',
        prefixIcon: prefixIcon,
        prefixIconColor: isDark ? Colors.white : Colors.black,
        suffixIcon: suffixIcon,
        suffixIconColor: isDark ? Colors.white : Colors.black,
        hintText: hintText,
        hintStyle: TextStyle(
          color: isDark ? Colors.white : Colors.black
        )
      )
    );
  }
}