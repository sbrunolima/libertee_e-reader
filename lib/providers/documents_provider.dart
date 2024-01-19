import 'package:flutter/foundation.dart';
import '../helpers/db_helper.dart';

//Objects
import '../providers/pdf_docs.dart';

class DocumentsProvider with ChangeNotifier {
  List<PdfDocs> _pdf = [];

  List<PdfDocs> get pdf {
    return [..._pdf];
  }

  PdfDocs findById(String id) {
    return _pdf.firstWhere((pdf) => pdf.id == id);
  }

  Future<void> addPdf(PdfDocs pdf) async {
    final timestamp = DateTime.now();

    final newPdf = PdfDocs(
      id: timestamp.toString().toLowerCase(),
      title: pdf.title,
      path: pdf.path,
      page: '0',
      size: pdf.size,
      status: 'unread',
      extension: pdf.extension,
      percent: '0',
    );

    _pdf.add(newPdf);
    notifyListeners();
    DBHelper.insertData(
      'user_notes',
      {
        'id': timestamp.toString().toLowerCase(),
        'title': newPdf.title.toString(),
        'path': newPdf.path.toString(),
        'page': '0',
        'size': newPdf.size.toString(),
        'status': 'unread',
        'extension': newPdf.extension.toString(),
        'percent': '0',
      },
    );

    print('SACED');
  }

  Future<void> loadAndSetPdf() async {
    final dataList = await DBHelper.getData('user_notes');
    _pdf = dataList
        .map(
          (pdf) => PdfDocs(
            id: pdf['id'].toString().toLowerCase(),
            title: pdf['title'],
            path: pdf['path'],
            page: pdf['page'],
            size: pdf['size'],
            status: pdf['status'],
            extension: pdf['extension'],
            percent: pdf['percent'],
          ),
        )
        .toList();

    notifyListeners();
  }

  Future<void> updatePdf(String id, PdfDocs editedPdf) async {
    final pdfIndex = _pdf.indexWhere((pdf) => pdf.id == id);
    if (pdfIndex >= 0) {
      DBHelper.insertData(
        'user_notes',
        {
          'id': editedPdf.id.toString().toLowerCase(),
          'title': editedPdf.title.toString(),
          'path': editedPdf.path.toString(),
          'page': editedPdf.page.toString(),
          'size': editedPdf.size.toString(),
          'status': editedPdf.status.toString(),
          'extension': editedPdf.extension.toString(),
          'percent': editedPdf.percent.toString(),
        },
      );

      print('EDITED');
      _pdf[pdfIndex] = editedPdf;

      notifyListeners();
    } else {
      return;
    }
  }

  Future<void> deletePdf(String id) async {
    final existingPdfIndex = _pdf.indexWhere((note) => note.id == id);

    _pdf.removeAt(existingPdfIndex);

    final db = await DBHelper.database();
    await db.delete(
      'user_notes',
      where: 'id = ?',
      whereArgs: [id],
    );
    print('DELETED: ${id}');
    notifyListeners();
  }
}
