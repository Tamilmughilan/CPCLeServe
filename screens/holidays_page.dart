import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class HolidaysPage extends StatelessWidget {
  const HolidaysPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Holidays'),
      ),
      body: const PDFViewerPage(),
    );
  }
}

class PDFViewerPage extends StatefulWidget {
  const PDFViewerPage({super.key});

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SfPdfViewer.asset(
          'assets/pdfs/ARM_CORE_EXTENSION.pdf',
          onDocumentLoaded: (PdfDocumentLoadedDetails details) {
            setState(() {
              _isLoading = false;
            });
          },
          onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
            setState(() {
              _isLoading = false;
              _errorMessage = details.error;
            });
            print('Error loading PDF: ${details.error}');
          },
        ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
        if (_errorMessage.isNotEmpty)
          Center(
            child: Text('Error: $_errorMessage'),
          ),
      ],
    );
  }
}