

import 'package:flutter/material.dart';

class AppTheme{

  static ThemeData themeData(){
    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: Colors.grey.shade300,
      inputDecorationTheme:  InputDecorationTheme(
        
        labelStyle: TextStyle(color: Colors.deepPurple.shade700),
        hintStyle: TextStyle(color: Colors.grey.shade400),
        prefixIconColor: Colors.deepPurple.shade700,
        focusColor: Colors.deepPurple.shade700,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.indigo)
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(20.0)
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(20.0)
        ),
      )
    );
  }

  


}