import 'package:flutter/material.dart';

InputDecoration buildInputDecoration(String hint, String? label,
    {bool isMandatory = false}) {
  return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      alignLabelWithHint: true,
      label: RichText(
        text: TextSpan(
            text: label,
            style: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
                fontWeight: FontWeight.w500),
            children: [
              TextSpan(
                  text: isMandatory ? " *" : "",
                  style: const TextStyle(color: Colors.red))
            ]),
      ),
      hintText: hint,
      labelStyle: const TextStyle(
          color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w600),
      hintStyle: const TextStyle(
          color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w600),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueAccent, width: 0.0),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xFFEBEBEB),
          width: 1,
        ),
      ),
      filled: true,
      isDense: true,
      fillColor: Colors.white);
}
