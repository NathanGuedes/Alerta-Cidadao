import 'dart:convert';

import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:novo_alerta_cidadao/models/alert_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class SheetsService {
  static const _spreadsheetId = '1D5XE__AmM07-_tk55uTOVestdraCK3j53zTFJlA5Ot0';
  static const _range = 'Alertas!A:H'; // Ajustado para 8 colunas (A-H)

  Future<void> sendAlertToSheets(AlertModel alert) async {
    try {
      // 1. Carregar credenciais do arquivo de assets
      final credentialsJson = await rootBundle.loadString('assets/alerta-cidadao-460014-440615bbea0d.json');
      final credentials = ServiceAccountCredentials.fromJson(json.decode(credentialsJson));

      // 2. Autenticar
      final client = await clientViaServiceAccount(
        credentials,
        [SheetsApi.spreadsheetsScope],
      );

      // 3. Preparar dados
      final newRow = _prepareAlertData(alert);

      // 4. Enviar para o Google Sheets
      await _sendDataToSheets(client, newRow);
    } catch (e) {
      debugPrint('Erro ao enviar para Google Sheets: $e');
      rethrow;
    }
  }

  List<dynamic> _prepareAlertData(AlertModel alert) {
    return [
      alert.id,
      alert.description,
      alert.problemType,
      alert.street,
      alert.neighborhood,
      alert.referencePoint,
      alert.imageUrls.join('|'), // Separa URLs por pipe
      alert.dateTime.toIso8601String(),
    ];
  }

  Future<void> _sendDataToSheets(AuthClient client, List<dynamic> newRow) async {
    final sheetsApi = SheetsApi(client);

    try {
      // Obter dados existentes
      final currentData = await sheetsApi.spreadsheets.values.get(
        _spreadsheetId,
        _range,
      );

      // Adicionar nova linha
      final updatedData = currentData.values ?? [];
      updatedData.add(newRow);

      // Atualizar planilha
      await sheetsApi.spreadsheets.values.update(
        ValueRange(values: updatedData),
        _spreadsheetId,
        _range,
        valueInputOption: 'USER_ENTERED',
      );
    } finally {
      client.close();
    }
  }
}