import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

//Providers
import '../providers/pdf_docs.dart';

class PortraitView extends StatefulWidget {
  final PdfDocs file;
  final String fileSize;
  final pdfDoc;

  PortraitView(
      {required this.file, required this.fileSize, required this.pdfDoc});

  @override
  State<PortraitView> createState() => _PortraitViewSatate();
}

class _PortraitViewSatate extends State<PortraitView> {
  @override
  Widget build(BuildContext context) {
    //Get the device size
    final mediaQuery = MediaQuery.of(context).size;
    //final pdfDoc = PdfDocument.openFile(widget.file.toString());
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Container(
              height: mediaQuery.height - 300,
              width: mediaQuery.width,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.circular(8.0),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.orange.withOpacity(0.5),
                //     spreadRadius: 2,
                //     blurRadius: 10,
                //     offset: const Offset(0, 0),
                //   ),
                // ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: PdfDocumentLoader(
                  doc: widget.pdfDoc,
                  pageNumber: 1,
                  pageBuilder: (context, textureBuilder, pageSize) =>
                      textureBuilder(),
                ),
              ),
            ),
          ),
        ),
        //const SizedBox(height: 20),
        bookTitle(
          widget.file.title,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            bookSubtitle(widget.file.extension.toUpperCase()),
            bookSubtitle(', '),
            bookSubtitle(widget.fileSize),
          ],
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget buttonText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        text,
        style: GoogleFonts.openSans(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget percentText(String percent) {
    return Center(
      child: Text(
        percent,
        style: GoogleFonts.openSans(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget bookTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: GoogleFonts.openSans(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget bookSubtitle(String subtitle) {
    return Text(
      subtitle,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.roboto(
        color: Colors.grey,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
