import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

//Providers
import '../providers/documents_provider.dart';

class DeletePopup extends StatelessWidget {
  final String bookID;
  //Callback function to refresh the page
  final Function(bool) callback;

  DeletePopup({required this.bookID, required this.callback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        showDialog(
          context: context,
          builder: (context) => Container(
            child: AlertDialog(
              backgroundColor: Colors.grey.shade900,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              title: Center(
                child: Text(
                  'Deletar PDF?',
                  style: GoogleFonts.openSans(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              actions: [
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                        width: 250,
                        child: OutlinedButton(
                          onPressed: () async {
                            await Provider.of<DocumentsProvider>(context,
                                    listen: false)
                                .deletePdf(
                              bookID,
                            );
                            callback(true);
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.transparent),
                          ),
                          child: Text(
                            'Deletar',
                            style: GoogleFonts.openSans(
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 40,
                        width: 250,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.transparent),
                          ),
                          child: Text(
                            'Cancelar',
                            style: GoogleFonts.openSans(
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
      child: const Icon(
        EneftyIcons.trash_bold,
        color: Colors.grey,
      ),
    );
  }
}
