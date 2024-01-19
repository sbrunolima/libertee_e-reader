import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarTitles extends StatelessWidget {
  final String title;

  AppBarTitles({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.openSans(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
