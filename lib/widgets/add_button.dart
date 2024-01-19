import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:enefty_icons/enefty_icons.dart';

//Providers
import '../providers/pdf_docs.dart';
import '../providers/documents_provider.dart';

class AddButtom extends StatefulWidget {
  //Callback function to refresh the page
  final Function(bool) callback;

  AddButtom({required this.callback});

  @override
  State<AddButtom> createState() => _AddButtomState();
}

class _AddButtomState extends State<AddButtom> {
  var _newNote = PdfDocs(
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
  Widget build(BuildContext context) {
    final pdfData = Provider.of<DocumentsProvider>(context, listen: false);
    final pdf = pdfData.pdf;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: GestureDetector(
        onTap: () async {
          final result = await FilePicker.platform.pickFiles(
            allowMultiple: true,
            type: FileType.custom,
            allowedExtensions: ['pdf'],
          );
          //if (result == null) return;

          //Open single file
          final file = result!.files.first;
          bool fileExists = false;

          //openFiles(result.files);
          if (result.files.length > 0) {
            for (int i = 0; i < result.files.length; i++) {
              _newNote = PdfDocs(
                id: result.files[i].name.toString(),
                title: result.files[i].name
                    .toString()
                    .substring(0, result.files[i].name.length - 4),
                path: result.files[i].path.toString(),
                page: '0',
                size: result.files[i].size.toString(),
                status: 'unread',
                extension: result.files[i].extension.toString(),
                percent: '0',
              );

              for (int j = 0; j < pdf.length; j++) {
                if (pdf[j].title == _newNote.title) {
                  setState(() {
                    fileExists = true;
                  });
                }
              }

              if (!fileExists) {
                await Provider.of<DocumentsProvider>(context, listen: false)
                    .addPdf(_newNote);
              }
            }

            print('FILEEEEE: ${result.files.length}');
          }

          widget.callback(true);

          // _newNote = PdfDocs(
          //   id: file.name.toString(),
          //   title: file.name.toString(),
          //   path: file.path.toString(),
          //   page: '1',
          // );

          // openFile(file);

          // await Provider.of<DocumentsProvider>(context, listen: false)
          //     .addPdf(_newNote);

          //print('FILEEEEE: ${result.files}');

          print('Name: ${file.name}');
          print('Bytes: ${file.bytes}');
          print('Size: ${file.size}');
          print('Extension: ${file.extension}');
          print('Path: ${file.path}');

          final newFile = await saveFilePermanently(file);

          print('From Path: ${file.path!}');
          print('To Path: ${newFile.path}');
        },
        child: Container(
          height: 35,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.circular(4),
            color: Colors.orange.shade900,
          ),
          child: Row(
            children: [
              Text(
                'Add',
                style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 2),
              const Icon(
                EneftyIcons.add_outline,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<File> saveFilePermanently(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStorage.path}/${file.name}');

    return File(file.path!).copy(newFile.path);
  }

  // void openFiles(List<PlatformFile> files) => Navigator.of(context).push(
  void openFile(PlatformFile file) {
    OpenFile.open(file.path!);
  }
}
