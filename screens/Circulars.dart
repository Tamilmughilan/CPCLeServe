import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CircularsPage extends StatefulWidget {
  final int prNo;
  final String department;

  const CircularsPage(
      {super.key, required this.prNo, required this.department});

  @override
  _CircularsPageState createState() => _CircularsPageState();
}

class _CircularsPageState extends State<CircularsPage> {
  List<String> _pdfs = []; // List to store PDF file names

  @override
  void initState() {
    super.initState();
    _loadPdfs();
  }

  Future<void> _loadPdfs() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5062/api/circulars/all'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> pdfList = jsonDecode(response.body);

        if (pdfList.every((item) => item is String)) {
          setState(() {
            _pdfs = pdfList.cast<String>();
          });
        } else {
          throw Exception('Unexpected JSON format');
        }
      } else {
        throw Exception(
            'Failed to load PDFs with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching PDFs: $e');
    }
  }

  Future<void> _downloadPdf(String fileName) async {
    try {
      final url = 'http://localhost:5062/api/circulars/download/$fileName';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/$fileName';
        final file = File(filePath);

        await file.writeAsBytes(bytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File downloaded to $filePath')),
        );
      } else {
        throw Exception('Failed to download PDF');
      }
    } catch (e) {
      print('Error downloading PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading PDF: $e')),
      );
    }
  }

  Future<void> _uploadPdf(BuildContext context) async {
    if (widget.department != "Information Systems") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You are not authorized to upload files.')),
      );
      return;
    }

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.single.path!);
        final fileName = result.files.single.name;

        final request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'http://localhost:5062/api/circulars/upload?prNo=${widget.prNo}'),
        );

        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            file.path,
            filename: fileName,
          ),
        );

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          _loadPdfs();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('File uploaded successfully')),
          );
        } else {
          throw Exception('Failed to upload PDF: ${response.body}');
        }
      }
    } catch (e) {
      print('Error uploading PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading PDF: $e')),
      );
    }
  }

  Future<void> _deletePdf(String fileName) async {
    if (widget.department != "Information Systems") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You are not authorized to delete files.')),
      );
      return;
    }

    try {
      final url =
          'http://localhost:5062/api/circulars/delete/$fileName?prNo=${widget.prNo}';
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        _loadPdfs();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File deleted successfully')),
        );
      } else {
        throw Exception('Failed to delete PDF');
      }
    } catch (e) {
      print('Error deleting PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Circulars'),
        actions: [
          if (widget.department == "Information Systems")
            IconButton(
              icon: const Icon(Icons.upload),
              onPressed: () => _uploadPdf(context),
            ),
        ],
      ),
      body: ListView.builder(
        itemCount: _pdfs.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _downloadPdf(_pdfs[index]);
            },
            child: Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                title: Text(_pdfs[index]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () => _downloadPdf(_pdfs[index]),
                    ),
                    if (widget.department == "Information Systems")
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deletePdf(_pdfs[index]),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
