import 'package:flutter/material.dart';
const double opacity=0.5;

const Color greenColor = Color(0xff173434);
const Color yellowColor = Color(0xffFFCB02);

const textInputDecoration = InputDecoration(



hintStyle: TextStyle(
  color: Colors.yellow


),

  fillColor: Color(0xff173434),
  filled: true,
  border: OutlineInputBorder(
    borderRadius: const BorderRadius.all(
      const Radius.circular(30.0),
    ),
  ),
  contentPadding: EdgeInsets.all(12.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xff173434), width: 2.0),
    borderRadius: const BorderRadius.all(Radius.circular(30.0))
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xff173434), width: 2.0),
      borderRadius: const BorderRadius.all(Radius.circular(30.0))
  ),
);

