// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pdf_render/pdf_render.dart';
// import 'package:provider/provider.dart';

// //Screens
// import 'pdf_reader_screen.dart';

// //Providers
// import '../providers/pdf_docs.dart';
// import '../providers/settings_provider.dart';

// //Widgets
// import '../widgets/my_back_icon.dart';
// import '../PDF_book_screen/portrait_view.dart';
// import '../PDF_book_screen/landscape_view.dart';

// class BookScreen extends StatefulWidget {
//   final PdfDocs file;

//   BookScreen({required this.file});

//   @override
//   State<BookScreen> createState() => _BookScreenState();
// }

// class _BookScreenState extends State<BookScreen> {
//   bool isReading = false;
//   //Take the percent page when  close the PDF
//   String loadedPercent = '';
//   //Take the cache page when  close the PDF
//   String cachePage = '0';

//   bool landscape = false;
//   double myWidth = 0;

//   var kb;
//   var mb;
//   var fileSize;

//   @override
//   void initState() {
//     super.initState();

//     Provider.of<SettingsProvider>(context, listen: false).loadAndSetSettings();

//     kb = int.parse(widget.file.size) / 1024;
//     mb = kb / 1024;
//     fileSize =
//         mb >= 1 ? '${mb.toStringAsFixed(2)} MB' : '${kb.toStringAsFixed(0)} KB';

//     //Set the is reading and the percent
//     isReading = widget.file.status == 'reading';
//     loadedPercent = widget.file.percent;
//   }

//   @override
//   Widget build(BuildContext context) {
//     //Get the device orientation
//     Orientation orientation = MediaQuery.of(context).orientation;
//     //Get the device size
//     final mediaQuery = MediaQuery.of(context).size;
//     //Load all files
//     final file = widget.file.path;
//     final pdfDoc = PdfDocument.openFile(file.toString());

//     //Verify the phoone orientation
//     if (orientation == Orientation.landscape) {
//       setState(() {
//         landscape = true;
//       });
//     } else {
//       setState(() {
//         landscape = false;
//       });
//     }

//     return Scaffold(
//       backgroundColor: Colors.grey.shade900,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         elevation: 0,
//         leading: MyBackIcon(),
//       ),
//       body: SingleChildScrollView(
//         child: landscape
//             ? LandscapeView(
//                 file: widget.file,
//                 fileSize: fileSize,
//                 pdfDoc: pdfDoc,
//               )
//             : PortraitView(
//                 file: widget.file,
//                 fileSize: fileSize,
//                 pdfDoc: pdfDoc,
//               ),
//       ),
//       floatingActionButton: Padding(
//         padding: EdgeInsets.symmetric(vertical: landscape ? 0 : 10),
//         child: GestureDetector(
//           onTap: () {
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => PdfReaderScreen(
//                   //Pass the file
//                   file: widget.file,
//                   //Take the cache page when close the PDF
//                   cachePage: int.parse(cachePage),
//                   //Set the pecent and cache page when close the PDF
//                   callback: (percent, page) {
//                     setState(() {
//                       loadedPercent = percent.toString();
//                       cachePage = page.toString();
//                     });
//                   },
//                 ),
//               ),
//             );
//           },
//           child: Container(
//             height: 55,
//             width: landscape ? mediaQuery.width - 340 : mediaQuery.width - 30,
//             color: Colors.orange.shade900,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   buttonText(isReading ? 'Continue Reading' : 'Start Reading'),
//                   Container(
//                     height: 55,
//                     width: 100,
//                     color: Colors.white24,
//                     child: percentText(
//                       '${double.parse(loadedPercent.toString()).toStringAsFixed(0)}%',
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buttonText(String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Text(
//         text,
//         style: GoogleFonts.openSans(
//           color: Colors.white,
//         ),
//       ),
//     );
//   }

//   Widget percentText(String percent) {
//     return Center(
//       child: Text(
//         percent,
//         style: GoogleFonts.openSans(
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }
