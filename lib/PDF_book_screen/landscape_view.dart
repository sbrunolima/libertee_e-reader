import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

//Providers
import '../providers/pdf_docs.dart';

class LandscapeView extends StatefulWidget {
  final PdfDocs file;
  final String fileSize;
  final pdfDoc;

  LandscapeView(
      {required this.file, required this.fileSize, required this.pdfDoc});

  @override
  State<LandscapeView> createState() => _LandscapeViewSatate();
}

class _LandscapeViewSatate extends State<LandscapeView> {
  @override
  Widget build(BuildContext context) {
    //Get the device size
    final mediaQuery = MediaQuery.of(context).size;
    //final pdfDoc = PdfDocument.openFile(widget.file.toString());
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
            child: Container(
              height: mediaQuery.height - 100,
              width: mediaQuery.width - 550,
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
          //const SizedBox(height: 20),

          Container(
            height: mediaQuery.height - 170,
            width: mediaQuery.width - 350,
            color: Colors.transparent,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  bookTitle(
                    widget.file.title,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      bookSubtitle(widget.file.extension.toUpperCase()),
                      bookSubtitle(', '),
                      bookSubtitle(widget.fileSize),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bookTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.start,
      style: GoogleFonts.openSans(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w500,
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
