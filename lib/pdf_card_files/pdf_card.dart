import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';

//Providers
import '../providers/pdf_docs.dart';

//Widgets
import '../widgets/book_title.dart';
import '../widgets/book_subtitles.dart';

class PdfCard extends StatefulWidget {
  final PdfDocs file;

  PdfCard({required this.file});

  @override
  State<PdfCard> createState() => _PdfCardState();
}

class _PdfCardState extends State<PdfCard> {
  var _isInit = true;
  var percentValue;
  var kb;
  var mb;
  var fileSize;

  var file;
  var pdfDoc;

  @override
  void initState() {
    super.initState();
    if (_isInit) {
      percentValue = double.parse(widget.file.percent) / 100;
      kb = int.parse(widget.file.size) / 1024;
      mb = kb / 1024;
      fileSize = mb >= 1 ? '${mb.toStringAsFixed(2)} MB' : '${kb.toString()}';

      file = widget.file.path;
      pdfDoc = PdfDocument.openFile(file.toString());
    }

    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 180,
        width: mediaQuery.width,
        color: Colors.transparent,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 130,
                width: mediaQuery.width,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  //Book Cover
                  SizedBox(
                    height: 180,
                    width: 110,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: PdfDocumentLoader(
                        doc: pdfDoc,
                        pageNumber: 1,
                        pageBuilder: (context, textureBuilder, pageSize) =>
                            textureBuilder(),
                      ),
                    ),
                  ),

                  //Book Title
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          color: Colors.transparent,
                          height: 70,
                          width: mediaQuery.width - 160,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: SizedBox(
                                  width: mediaQuery.width - 180,
                                  child: BookTitle(
                                    title: widget.file.title,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              //Book Type
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    BookSubtitle(
                                        subtitle: widget.file.extension
                                            .toUpperCase()),
                                    BookSubtitle(subtitle: ', '),
                                    BookSubtitle(subtitle: fileSize),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        //Percent Bar
                        Container(
                          height: 40,
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  progressText('Progress'),
                                  percentText(widget.file.percent)
                                ],
                              ),
                              LinearPercentIndicator(
                                width: mediaQuery.width - 160,
                                lineHeight: 4.0,
                                percent: percentValue,
                                progressColor: Colors.orange,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget progressText(String progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9),
      child: Text(
        progress,
        style: GoogleFonts.openSans(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget percentText(String percent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        '${double.parse(percent).toStringAsFixed(0)}%',
        style: GoogleFonts.openSans(
          color: Colors.orange,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
