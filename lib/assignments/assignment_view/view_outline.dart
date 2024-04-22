import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewOutline extends StatelessWidget{
  final String url;

  const ViewOutline({super.key, required this.url});


  @override
  Widget build(BuildContext context) {

    PdfViewerController pdfController = PdfViewerController();
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text("Assignment Outline"),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                pdfController.zoomLevel += 1.25;
              },
              icon: const Icon(
                Icons.zoom_in, color: Colors.white,
              ),
          )
        ],
      ),
      body: SfPdfViewer.network(
        url,
        controller: pdfController,),
    ));
  }
}