import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';

//Providers
import '../providers/documents_provider.dart';
import '../language/app_language.dart';

//Screens
import '../screens/pdf_reader_screen.dart';

//Widgets
import '../widgets/app_bar_titles.dart';
import '../widgets/add_button.dart';
import '../widgets/book_title.dart';
import '../widgets/book_subtitles.dart';
import '../widgets/delete_popup.dart';

class AllBooksScreen extends StatefulWidget {
  @override
  State<AllBooksScreen> createState() => _AllBooksScreenState();
}

class _AllBooksScreenState extends State<AllBooksScreen> {
  var _isInit = true;
  var isLoading = false;
  String directory = '';
  List allFile = [];
  List loadedFiles = [];
  bool isPdf = false;
  //Take the percent page when  close the PDF
  String loadedPercent = '';
  //Take the cache page when  close the PDF
  String cachePage = '0';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      isLoading = true;
    });

    if (_isInit) {
      Provider.of<DocumentsProvider>(context, listen: false)
          .loadAndSetPdf()
          .then((value) {
        setState(() {
          isLoading = false;
        });
      });
    }

    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    //Load the phone Locale
    //--------------------------------------------------------------------------
    final localeData = Provider.of<LanguageProvider>(context);
    final pdfData = Provider.of<DocumentsProvider>(context, listen: false);
    final pdf = pdfData.pdf;

    if (isLoading) {
      Provider.of<DocumentsProvider>(context, listen: false)
          .loadAndSetPdf()
          .then((value) {
        setState(() {
          isLoading = false;
        });
      });
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: AppBarTitles(
            title: localeData.language[0].library!.isNotEmpty
                ? localeData.language[0].library!
                : 'All Books'),
        centerTitle: true,
        actions: [
          AddButtom(
            callback: (value) {
              setState(() {
                _isInit = value;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              reverse: true,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 6),
              itemCount: pdf.length,
              itemBuilder: (context, index) {
                final percentValue = double.parse(pdf[index].percent) / 100;
                final kb = int.parse(pdf[index].size) / 1024;
                final mb = kb / 1024;
                final fileSize = mb >= 1
                    ? '${mb.toStringAsFixed(2)} MB'
                    : '${kb.toStringAsFixed(0)} KB';

                final file = pdf[index].path;
                final pdfDoc = PdfDocument.openFile(file.toString());
                //Open the book and when return load all data again
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (context) => PdfReaderScreen(
                              file: pdf[index],
                            ),
                          ),
                        )
                        //load all data again
                        .then(
                          (_) => setState(() {
                            isLoading = true;
                          }),
                        );
                  },
                  child: Padding(
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
                                      pageBuilder:
                                          (context, textureBuilder, pageSize) =>
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
                                        child: Stack(
                                          children: [
                                            //Delete book Button
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Container(
                                                width: 40,
                                                color: Colors.transparent,
                                                child: DeletePopup(
                                                  bookID: pdf[index].id,
                                                  callback: (value) {
                                                    setState(() {
                                                      _isInit = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                            //Book title
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: SizedBox(
                                                    width:
                                                        mediaQuery.width - 180,
                                                    child: BookTitle(
                                                      title: pdf[index].title,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                //Book Type
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: Row(
                                                    children: [
                                                      BookSubtitle(
                                                          subtitle: pdf[index]
                                                              .extension
                                                              .toUpperCase()),
                                                      BookSubtitle(
                                                          subtitle: ', '),
                                                      BookSubtitle(
                                                          subtitle: fileSize),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      //Percent Bar
                                      Container(
                                        height: 40,
                                        color: Colors.transparent,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                progressText(localeData
                                                        .language[0]
                                                        .progress!
                                                        .isNotEmpty
                                                    ? localeData
                                                        .language[0].progress!
                                                    : 'Progress'),
                                                percentText(pdf[index].percent)
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
                  ),
                );
              },
            ),
            const SizedBox(height: 140),
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
