import 'package:flutter/material.dart';
import 'package:novo_alerta_cidadao/controllers/alert_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerta Cidadão'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showAppInfo(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 150,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 40),
            _buildReportButton(context),
            const SizedBox(height: 20),
            _buildRecentReportsButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildReportButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.report_problem, size: 24),
        label: const Text(
          'FAZER ALERTA',
          style: TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () => AlertController().startAlertFlow(context),
      ),
    );
  }

  Widget _buildRecentReportsButton(BuildContext context) {
    return TextButton(
      child: const Text(
        'Visualizar alertas recentes',
        style: TextStyle(fontSize: 16),
      ),
      onPressed: () {
        // Navegar para tela de alertas recentes
      },
    );
  }

  void _showAppInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sobre o App'),
        content: const Text(
          'Alerta Cidadão permite reportar problemas urbanos '
          'para as autoridades competentes de forma rápida e fácil.\n\n'
          'Versão 1.0.0',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}