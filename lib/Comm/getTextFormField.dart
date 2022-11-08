import 'package:flutter/material.dart';

class genTextFormField extends StatelessWidget {
  TextEditingController controller;
  String hintName;
  IconData iconData;
  TextInputType textInputType;

  genTextFormField(
      {required this.controller,
      required this.hintName,
      required this.iconData,
      this.textInputType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      decoration: InputDecoration(
          icon: Icon(iconData),
          hintText: hintName,
          labelText: "Please Enter $hintName",
          fillColor: Colors.grey[200],
          filled: true),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please Enter $hintName';
        }
        if (hintName == "Email" && !validateEmail(value)) {
          return 'Please Enter Valid Email';
        }
      },
    );
  }
}

validateEmail(String email) {
  final emailReg = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  return emailReg.hasMatch(email);
}
