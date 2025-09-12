import "package:flutter/material.dart";

class Textfile extends StatefulWidget {
  final String labelText;
  final Icon icon;
  final bool isPassword;
  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const Textfile({
    super.key,
    required this.labelText,
    required this.icon,
    this.isPassword = false,
    required this.controller,
    this.errorText,
    this.onChanged,
  });

  @override
  State<Textfile> createState() => _TextfileState();
}

class _TextfileState extends State<Textfile> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.labelText,
        prefixIcon: widget.icon,
        errorText: widget.errorText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
        suffixIcon:
            widget.isPassword
                ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
                : null,
      ),
    );
  }
}
