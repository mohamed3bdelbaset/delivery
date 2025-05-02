import 'package:delivery_app/Shared/Shared_widget/responsive_widget.dart';
import 'package:flutter/material.dart';

enum Fieldtype { email, password, text, phone }

class fieldmodel {
  final String? labelText;
  final IconData? icon;
  final TextInputType? texttype;
  final TextInputAction? actiontype;
  TextEditingController? controller;
  bool issecure;
  final Fieldtype? fieldtype;
  bool enabled;
  final Key? key;
  final int? lenght;
  Function? onSubmit = () {};
  final String? hinttext;
  bool autofocus;

  fieldmodel(
      {this.icon,
      this.labelText,
      this.texttype,
      this.controller,
      this.actiontype,
      this.issecure = false,
      this.fieldtype = Fieldtype.text,
      this.enabled = true,
      this.key,
      this.lenght,
      this.onSubmit,
      this.hinttext,
      this.autofocus = false});
}

class Custom_filed extends StatefulWidget {
  final fieldmodel model;
  const Custom_filed(this.model, {super.key});

  @override
  State<Custom_filed> createState() => _custom_filedState();
}

class _custom_filedState extends State<Custom_filed> {
  @override
  Widget build(BuildContext context) {
    double textmiddlefont = middletext(MediaQuery.of(context).size.height);
    return TextFormField(
      key: widget.model.key,
      validator: (x) {
        if (x!.isEmpty) {
          return 'some field requird';
        }
        return null;
      },
      decoration: InputDecoration(
          border: _filedborder(Colors.black),
          errorBorder: _filedborder(Colors.red),
          focusedBorder: _filedborder(Colors.grey),
          focusedErrorBorder: _filedborder(Colors.red),
          disabledBorder: _filedborder(Colors.grey),
          prefixIcon: Icon(
            widget.model.icon,
            color: Colors.black38,
            size: 20,
          ),
          labelText: widget.model.labelText,
          labelStyle: TextStyle(color: Colors.grey, fontSize: textmiddlefont),
          hintText: widget.model.hinttext,
          hintStyle: TextStyle(fontSize: textmiddlefont),
          suffixIcon: widget.model.fieldtype == Fieldtype.password
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      widget.model.issecure = !widget.model.issecure;
                    });
                  },
                  icon: Icon(Icons.remove_red_eye_outlined),
                  iconSize: 20,
                  color: Colors.grey,
                )
              : SizedBox()),
      keyboardType: widget.model.texttype,
      textInputAction: widget.model.actiontype,
      controller: widget.model.controller,
      obscureText: widget.model.issecure,
      enabled: widget.model.enabled,
      maxLength: widget.model.lenght,
      onFieldSubmitted: (x) {
        widget.model.onSubmit!();
      },
      autofocus: widget.model.autofocus,
    );
  }
}

OutlineInputBorder _filedborder(Color color) {
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: color, width: 1.0));
}
