import 'package:flutter/material.dart';
import 'package:novo_alerta_cidadao/models/alert_model.dart';
import 'package:novo_alerta_cidadao/services/image_service.dart';
import 'package:novo_alerta_cidadao/services/location_service.dart';
import 'package:novo_alerta_cidadao/services/sheets_service.dart';
import 'package:novo_alerta_cidadao/views/alert_form.dart';

class AlertController {
  Future<void> startAlertFlow(BuildContext context) async {
    try {
      // 1. Captura de imagens
      final images = await ImageService().pickImages(context);
      
      if (images.isEmpty) return;
      
      // 2. Obter localização (se disponível)
      final location = await LocationService().getCurrentLocation();
      
      // 3. Mostrar formulário
      final alert = await _showAlertForm(context, images, location);
      
      if (alert != null) {
        // 4. Enviar para o Google Sheets
        await SheetsService().sendAlertToSheets(alert);
        
        // 5. Mostrar confirmação
        _showSuccessDialog(context);
      }
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  Future<AlertModel?> _showAlertForm(BuildContext context, List<String> imagePaths, LocationData? location) async {
    // Implementar o diálogo de formulário
    return showDialog<AlertModel>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Preencher Alerta'),
        content: AlertForm(imagePaths: imagePaths, location: location),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              // Validar e retornar os dados
              // Navigator.pop(context, alertModel);
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sucesso'),
        content: const Text('Alerta enviado com sucesso!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro'),
        content: Text('Ocorreu um erro: $error'),
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