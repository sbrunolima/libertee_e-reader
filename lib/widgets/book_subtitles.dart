import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookSubtitle extends StatelessWidget {
  final String subtitle;

  BookSubtitle({required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Text(
      subtitle,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.roboto(
        color: Colors.grey,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
