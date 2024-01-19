import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OptionsButtons extends StatefulWidget {
  final String title;
  final String content;
  final bool isClickable;

  OptionsButtons(
      {required this.title, required this.content, required this.isClickable});
  @override
  State<OptionsButtons> createState() => _OptionsButtonsState();
}

class _OptionsButtonsState extends State<OptionsButtons> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent),
        borderRadius: BorderRadius.circular(8.0),
        color: widget.isClickable ? Colors.white12 : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              titlesText(title: widget.title),
              const SizedBox(width: 8.0),
              if (widget.isClickable)
                Image.asset(
                  'assets/premium.png',
                  height: 20,
                  width: 20,
                )
            ],
          ),
          const SizedBox(height: 10),
          contenttext(content: widget.content),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget contenttext({required String content}) {
    return Text(
      content,
      style: GoogleFonts.openSans(color: Colors.white),
    );
  }

  Widget titlesText({required String title}) {
    return Text(
      title,
      style: GoogleFonts.openSans(
        fontSize: 16,
        color: Colors.orange,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
