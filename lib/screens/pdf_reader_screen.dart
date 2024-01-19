import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

//Providers
import '../providers/pdf_docs.dart';
import '../providers/documents_provider.dart';
import '../providers/settings_provider.dart';

//Widgets
import '../widgets/app_bar_titles.dart';

class PdfReaderScreen extends StatefulWidget {
  final PdfDocs file;

  PdfReaderScreen({required this.file});

  @override
  State<PdfReaderScreen> createState() => _PdfReaderScreenState();
}

class _PdfReaderScreenState extends State<PdfReaderScreen> {
  String actualPage = '';
  String totalPages = '';
  int startPage = 0;
  String returnPage = '';
  bool activeAppBar = false;
  bool nightMode = false;
  double bookPercent = 0;
  bool isLoading = false;

  var _newPDF = PdfDocs(
    id: '',
    title: '',
    path: '',
    page: '',
    size: '',
    status: '',
    extension: '',
    percent: '',
  );

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);

    setState(() {
      isLoading = true;
    });
    startPage = int.parse(widget.file.page);

    Future.delayed(const Duration(seconds: 1)).then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    //Load all PDF files
    final settingsData = Provider.of<SettingsProvider>(context, listen: false);
    final appSettings = settingsData.appSettings;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(context);

        return true;
      },
      child: Scaffold(
        appBar: activeAppBar
            ? AppBar(
                backgroundColor: Colors.black,
                leading: GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                title: AppBarTitles(title: widget.file.title),
              )
            : null,
        body: isLoading
            ? Center(child: Image.asset('assets/loading.gif'))
            : Stack(
                children: [
                  PDFView(
                    filePath: widget.file.path,
                    autoSpacing: true,
                    fitEachPage: true,
                    swipeHorizontal:
                        appSettings[0].swipeHorizontal == '0' ? false : true,
                    nightMode: appSettings[0].nightMode == '0' ? false : true,
                    defaultPage: startPage,
                    onPageChanged: (page, total) async {
                      //Set the state of actualPage and totalPages
                      setState(() {
                        actualPage = page.toString();
                        totalPages = total.toString();
                        returnPage = actualPage;
                      });

                      //Get the percents
                      bookPercent =
                          (int.parse(actualPage) / int.parse(totalPages)) * 100;

                      //Set the PDF status
                      _newPDF = PdfDocs(
                        id: widget.file.id.toString(),
                        title: widget.file.title.toString(),
                        path: widget.file.path.toString(),
                        page: page.toString(),
                        size: widget.file.size.toString(),
                        status: 'reading',
                        extension: widget.file.extension.toString(),
                        percent: bookPercent.toString(),
                      );

                      //Save the _newPDF status on the DocumentProvider
                      await Provider.of<DocumentsProvider>(context,
                              listen: false)
                          .updatePdf(widget.file.id.toString(), _newPDF)
                          .then((value) {});
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: pageNumber(pageNumber: actualPage),
                  ),
                ],
              ),
        floatingActionButton: SizedBox(
          height: 45,
          width: 45,
          child: FloatingActionButton(
            elevation: 0,
            onPressed: () {
              setState(() {
                activeAppBar = !activeAppBar;
              });
            },
            backgroundColor: Colors.orange.shade900,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(
              activeAppBar ? Icons.close : Icons.arrow_drop_up_sharp,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget pageNumber({required String pageNumber}) {
    return Container(
      width: 60,
      height: 26,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Center(
        child: Text(
          pageNumber,
          style: GoogleFonts.openSans(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
