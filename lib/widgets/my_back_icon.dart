import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Providers
import '../providers/documents_provider.dart';

class MyBackIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Provider.of<DocumentsProvider>(context, listen: false)
            .loadAndSetPdf();
        Navigator.of(context).pop(context);
      },
      child: const Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
    );
  }
}
