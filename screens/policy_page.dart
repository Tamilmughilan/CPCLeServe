import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PolicyPage extends StatelessWidget {
  const PolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final policies = [
      {
        'name': 'RISK MANAGEMENT POLICY',
        'filename': 'Risk-Management-Policy.pdf'
      },
      {
        'name':
            'CODE FOR PREVENTION OF INSIDER TRADING IN THE SECURITIES OF CPCL',
        'filename': 'Insider Trading.pdf'
      },
      {
        'name': 'CDA RULES AS AMENDED ON 27.05.2020',
        'filename': 'CDA-Rules-amended-as-on-27.05.2020.pdf'
      },
      {'name': 'CODE OF CONDUCT CPCL', 'filename': 'Code of Conduct_CPCL.pdf'},
      {
        'name': 'COMPLIANCE OFFICER FOR MATERIALS POLICY',
        'filename': 'COMPLIANCE-OFFICER-FOR-MATERIALS-POLICY.pdf'
      },
      {
        'name': 'CPCL CONCILIATION RULES 2018',
        'filename': 'CPCL Concilliation Rules 2018.pdf'
      },
      {'name': 'CPCL CSR POLICY', 'filename': 'CPCL CSR Policy (1).pdf'},
      {
        'name': 'DIVIDEND DISTRIBUTION POLICY',
        'filename': 'Dividend Distribution Policy.pdf'
      },
      {'name': 'MATERIAL POLICY 2016', 'filename': 'Material Policy-2016.pdf'},
      {
        'name': 'NITI AAYOG REVIVAL OF CONSTRUCTION SECTOR',
        'filename': 'Niti Ayog-Revival of Construction Sector.pdf'
      },
      {
        'name': 'POLICY FOR PRESERVATION OF DOCUMENTS - 2016',
        'filename': 'Policy for Preservation of Documents - 2016.pdf'
      },
      {
        'name': 'RELATED PARTY TRANSACTION POLICY 2024',
        'filename': 'Related-Party-Transaction-Policy2024.pdf'
      },
      {
        'name': 'SAFETY, HEALTH & ENVIRONMENT',
        'filename': 'Safety, Health & Environment.pdf'
      },
      {
        'name': 'WHISTLE BLOWER POLICY 2019',
        'filename': 'Whistle Blower Policy -2019.pdf'
      },
      {
        'name': 'SUSTAINABILITY REPORT',
        'filename': 'Sustainability-Report.pdf'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Policies'),
      ),
      body: ListView.builder(
        itemCount: policies.length,
        itemBuilder: (context, index) {
          final policy = policies[index];
          return PolicyTile(
            name: policy['name']!,
            pdfPath: 'assets/Policies/${policy['filename']}',
          );
        },
      ),
    );
  }
}

class PolicyTile extends StatefulWidget {
  final String name;
  final String pdfPath;

  const PolicyTile({super.key, required this.name, required this.pdfPath});

  @override
  _PolicyTileState createState() => _PolicyTileState();
}

class _PolicyTileState extends State<PolicyTile> {
  final _scale = ValueNotifier<double>(1.0);
  final _color = ValueNotifier<Color>(Colors.transparent);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        _scale.value = 1.05;
        _color.value = Colors.blue.withOpacity(0.1);
      },
      onExit: (_) {
        _scale.value = 1.0;
        _color.value = Colors.transparent;
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PolicyViewerPage(pdfPath: widget.pdfPath),
            ),
          );
        },
        child: ValueListenableBuilder<double>(
          valueListenable: _scale,
          builder: (context, scale, child) {
            return ValueListenableBuilder<Color>(
              valueListenable: _color,
              builder: (context, color, child) {
                return AnimatedScale(
                  scale: scale,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        widget.name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class PolicyViewerPage extends StatefulWidget {
  final String pdfPath;
  const PolicyViewerPage({super.key, required this.pdfPath});

  @override
  _PolicyViewerPageState createState() => _PolicyViewerPageState();
}

class _PolicyViewerPageState extends State<PolicyViewerPage> {
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Policy Viewer'),
      ),
      body: Stack(
        children: [
          SfPdfViewer.asset(
            widget.pdfPath,
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
      ),
    );
  }
}
