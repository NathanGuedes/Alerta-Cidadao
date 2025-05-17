import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<List<String>> pickImages(BuildContext context) async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecionar imagem'),
        content: const Text('Escolha a fonte da imagem:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: const Text('Câmera'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: const Text('Galeria'),
          ),
        ],
      ),
    );

    if (source == null) return [];

    List<XFile> pickedFiles;
    
    if (source == ImageSource.camera) {
      // Se selecionou câmera, captura uma única foto
      final XFile? photo = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      pickedFiles = photo != null ? [photo] : [];
    } else {
      // Se selecionou galeria, permite múltiplas imagens
      pickedFiles = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
    }

    if (pickedFiles.isEmpty) return [];

    // Upload para o Imgur
    final imageUrls = <String>[];
    for (final file in pickedFiles) {
      final url = await _uploadToImgur(File(file.path));
      if (url != null) imageUrls.add(url);
    }

    return imageUrls;
  }

  Future<String?> _uploadToImgur(File image) async {
    const clientId = 'ca14e86a8f32fd6'; // Cliente ID do Imgur
    
    try {
      // Reduzir o tamanho da imagem se for muito grande
      final bytes = await image.readAsBytes();
      
      // API do Imgur tem limite de tamanho, então garantimos que não seja maior que ~8MB
      if (bytes.length > 8 * 1024 * 1024) {
        print('Imagem muito grande: ${bytes.length} bytes');
        return null;
      }
      
      final base64Image = base64Encode(bytes);
      
      final response = await http.post(
        Uri.parse('https://api.imgur.com/3/image'),
        headers: {
          'Authorization': 'Client-ID $clientId',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: {
          'image': base64Image,
          'type': 'base64'
        },
      ).timeout(const Duration(seconds: 30)); // Adiciona timeout

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']['link'];
      } else {
        print('Erro na API do Imgur: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Erro no upload para Imgur: $e');
    }
    return null;
  }
}