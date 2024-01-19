import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookTitle extends StatelessWidget {
  final String title;

  BookTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.openSans(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
    );
  }
}
