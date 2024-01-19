import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:epub_view/epub_view.dart' as epubview;
import 'package:provider/provider.dart';

//Providers
import '../providers/pdf_docs.dart';
import '../providers/documents_provider.dart';

//Widgets
import '../widgets/app_bar_titles.dart';

class EpubReaderScreen extends StatefulWidget {
  final PdfDocs file;

  EpubReaderScreen({required this.file});
  @override
  State<EpubReaderScreen> createState() => _EpubReadeScreenState();
}

class _EpubReadeScreenState extends State<EpubReaderScreen> {
  late epubview.EpubController _epubController;

  var cfi;
  String actualPage = '';
  String totalPages = '';
  int startPage = 0;
  String returnPage = '';
  bool activeAppBar = false;
  bool nightMode = false;
  double bookPercent = 0;
  bool isLoading = false;
  bool isInit = true;

  var newPDF = PdfDocs(
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
    File loadedFile = File(widget.file.path);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);

    setState(() {
      isLoading = true;
    });

    if (isInit) {
      if (widget.file.status.toLowerCase() == 'reading') {
        _epubController = epubview.EpubController(
          document: epubview.EpubDocument.openFile(loadedFile),
          epubCfi: widget.file.page.toString(),
        );
      } else {
        _epubController = epubview.EpubController(
          document: epubview.EpubDocument.openFile(loadedFile),
        );
      }
    }

    Future.delayed(const Duration(seconds: 2)).then((_) {
      setState(() {
        isLoading = false;
      });
    });

    isInit = false;

    //print('cfOINIT => ${widget.file.page}');
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                epubview.EpubView(
                  builders:
                      epubview.EpubViewBuilders<epubview.DefaultBuilderOptions>(
                    options: const epubview.DefaultBuilderOptions(),
                    chapterDividerBuilder: (_) => const Divider(),
                  ),
                  controller: _epubController,
                  onDocumentLoaded: (document) {
                    _epubController.gotoEpubCfi(widget.file.page);
                  },
                  onChapterChanged: (chapter) {
                    _epubController.gotoEpubCfi(widget.file.page);
                    newPDF = PdfDocs(
                      id: widget.file.id.toString(),
                      title: widget.file.title.toString(),
                      path: widget.file.path.toString(),
                      page: _epubController.generateEpubCfi().toString(),
                      size: widget.file.size.toString(),
                      status: 'reading',
                      extension: widget.file.extension.toString(),
                      percent: bookPercent.toString(),
                    );

                    //Save the _newPDF status on the DocumentProvider
                    Provider.of<DocumentsProvider>(context, listen: false)
                        .updatePdf(widget.file.id.toString(), newPDF)
                        .then((value) {});
                  },
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
    );
  }
}
