import 'package:flutter/material.dart';
import 'package:shop_core/l10n/app_localizations.dart';

class MySearchBar extends StatelessWidget {
  final Function(String)? onChanged;
  const MySearchBar({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide.none,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          cursorColor: const Color(0xff2A4ECA),
          style: const TextStyle(color: Colors.black87, fontSize: 15),
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 10,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Colors.black,
              size: 22,
            ),
            hintText: language.searchProduct,
            hintStyle: const TextStyle(color: Colors.black45, fontSize: 15),
            filled: true,
            fillColor: Colors.white,
            border: border,
            enabledBorder: border,
            focusedBorder: border,
          ),
        ),
      ),
    );
  }
}
