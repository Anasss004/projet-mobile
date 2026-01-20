import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/admin_costume_service.dart';
import '../services/category_service.dart';

class CreateCostumeScreen extends StatefulWidget {
  const CreateCostumeScreen({super.key});

  @override
  State<CreateCostumeScreen> createState() => _CreateCostumeScreenState();
}

class _CreateCostumeScreenState extends State<CreateCostumeScreen> {
  final _formKey = GlobalKey<FormState>();
  final AdminCostumeService _costumeService = AdminCostumeService();
  final CategoryService _categoryService = CategoryService();
  
  final _nomController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _prixController = TextEditingController();
  final _stockController = TextEditingController();
  final _imageUrlController = TextEditingController();
  
  File? _pickedImage;
  String? _selectedTaille;
  String? _selectedCategorie;
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = false;
  bool _categoriesLoaded = false;

  final List<String> _tailles = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categories = await _categoryService.getCategories();
    setState(() {
      _categories = categories;
      _categoriesLoaded = true;
      if (_categories.isNotEmpty) {
        _selectedCategorie = _categories[0]['id'].toString();
      }
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
        // Clear manual URL if image is picked to avoid confusion
        _imageUrlController.clear();
      });
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _descriptionController.dispose();
    _prixController.dispose();
    _stockController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedTaille == null || _selectedCategorie == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await _costumeService.createCostume(
      nom: _nomController.text.trim(),
      description: _descriptionController.text.trim().isEmpty 
          ? null 
          : _descriptionController.text.trim(),
      prixJournalier: double.parse(_prixController.text),
      taille: _selectedTaille!,
      stock: int.parse(_stockController.text),
      categorieId: int.parse(_selectedCategorie!),
      imageUrl: _imageUrlController.text.trim().isEmpty ? null : _imageUrlController.text.trim(),
      imageFile: _pickedImage,
    );

    setState(() {
      _isLoading = false;
    });

    if (result['success'] == true) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true); // Return true to indicate success
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un Costume'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(
                  labelText: 'Nom du costume *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le nom est requis';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              
              // Image Picker Section
              Center(
                child: Column(
                  children: [
                    if (_pickedImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(_pickedImage!, height: 150, width: 150, fit: BoxFit.cover),
                      )
                    else
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: const Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                      ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Choisir une photo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL de l\'image (ou chemin assets)',
                  border: OutlineInputBorder(),
                  hintText: 'ex: http://... ou assets/images/photo.png',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedTaille,
                decoration: const InputDecoration(
                  labelText: 'Taille *',
                  border: OutlineInputBorder(),
                ),
                items: _tailles.map((taille) {
                  return DropdownMenuItem(
                    value: taille,
                    child: Text(taille),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTaille = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'La taille est requise';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (_categoriesLoaded)
                DropdownButtonFormField<String>(
                  value: _selectedCategorie,
                  decoration: const InputDecoration(
                    labelText: 'Catégorie *',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.map((categorie) {
                    return DropdownMenuItem(
                      value: categorie['id'].toString(),
                      child: Text(categorie['nom']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategorie = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'La catégorie est requise';
                    }
                    return null;
                  },
                )
              else
                const CircularProgressIndicator(),
              const SizedBox(height: 16),
              TextFormField(
                controller: _prixController,
                decoration: const InputDecoration(
                  labelText: 'Prix journalier (€) *',
                  border: OutlineInputBorder(),
                  prefixText: '€ ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le prix est requis';
                  }
                  if (double.tryParse(value) == null || double.parse(value) < 0) {
                    return 'Prix invalide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(
                  labelText: 'Stock initial *',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le stock est requis';
                  }
                  if (int.tryParse(value) == null || int.parse(value) < 0) {
                    return 'Stock invalide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Créer le costume',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

