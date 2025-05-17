import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:novo_alerta_cidadao/models/alert_model.dart';
import 'package:novo_alerta_cidadao/services/location_service.dart';

class AlertForm extends StatefulWidget {
  final List<String> imagePaths;
  final LocationData? location;

  const AlertForm({
    super.key,
    required this.imagePaths,
    this.location,
  });

  @override
  State<AlertForm> createState() => _AlertFormState();
}

class _AlertFormState extends State<AlertForm> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _streetController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _referenceController = TextEditingController();
  
  String _problemType = 'Buraco';
  final List<String> _problemTypes = [
    'Buraco na via',
    'Falta de iluminação',
    'Lixo acumulado',
    'Vazamento de esgoto',
    'Poda de árvores',
    'Sinalização deficiente',
    'Obra irregular',
    'Outros'
  ];

  @override
  void initState() {
    super.initState();
    _initializeFormWithLocation();
  }

  void _initializeFormWithLocation() {
    if (widget.location != null) {
      _streetController.text = widget.location!.street?.trim() ?? '';
      _neighborhoodController.text = widget.location!.neighborhood?.trim() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImagePreview(),
            const SizedBox(height: 20),
            _buildDescriptionField(),
            const SizedBox(height: 16),
            _buildProblemTypeDropdown(),
            const SizedBox(height: 16),
            _buildStreetField(),
            const SizedBox(height: 16),
            _buildNeighborhoodField(),
            const SizedBox(height: 16),
            _buildReferenceField(),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.imagePaths.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(widget.imagePaths[index]),
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: InputDecoration(
        labelText: 'Descrição detalhada do problema',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      maxLines: 3,
      validator: (value) => value?.isEmpty ?? true 
          ? 'Por favor, descreva o problema com detalhes' 
          : null,
    );
  }

  Widget _buildProblemTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _problemType,
      items: _problemTypes.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) => setState(() => _problemType = value!),
      decoration: InputDecoration(
        labelText: 'Tipo de problema',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: (value) => value?.isEmpty ?? true 
          ? 'Selecione o tipo de problema' 
          : null,
    );
  }

  Widget _buildStreetField() {
    return TextFormField(
      controller: _streetController,
      decoration: InputDecoration(
        labelText: 'Rua/Avenida',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: (value) => value?.isEmpty ?? true 
          ? 'Informe o nome da rua ou avenida' 
          : null,
    );
  }

  Widget _buildNeighborhoodField() {
    return TextFormField(
      controller: _neighborhoodController,
      decoration: InputDecoration(
        labelText: 'Bairro',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: (value) => value?.isEmpty ?? true 
          ? 'Informe o bairro' 
          : null,
    );
  }

  Widget _buildReferenceField() {
    return TextFormField(
      controller: _referenceController,
      decoration: InputDecoration(
        labelText: 'Ponto de referência',
        hintText: 'Ex: Próximo ao mercado X, em frente ao prédio Y',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: (value) => value?.isEmpty ?? true 
          ? 'Informe um ponto de referência' 
          : null,
    );
  }

  AlertModel? getAlertData() {
    if (_formKey.currentState?.validate() ?? false) {
      return AlertModel(
        id: const Uuid().v4(),
        description: _descriptionController.text.trim(),
        problemType: _problemType.trim(),
        street: _streetController.text.trim(),
        neighborhood: _neighborhoodController.text.trim(),
        referencePoint: _referenceController.text.trim(),
        imageUrls: widget.imagePaths,
        dateTime: DateTime.now(),
      );
    }
    return null;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _streetController.dispose();
    _neighborhoodController.dispose();
    _referenceController.dispose();
    super.dispose();
  }
}