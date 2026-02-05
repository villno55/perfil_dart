import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  final TextEditingController _celularController =
      TextEditingController(text: "3001234567");

  final String nombre = "Juan";
  final String apellido = "Pérez";
  final String correo = "juanperez@email.com";
  final String documento = "CC 123456789";
  final String fechaNacimiento = "1999-05-20";

  Future<void> _pickImage() async {
    final picked =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() => _profileImage = File(picked.path));
    }
  }

  bool _matchesSearch(String text) {
    if (_searchText.isEmpty) return true;
    return text.toLowerCase().contains(_searchText.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() => _searchText = value);
              },
              decoration: InputDecoration(
                hintText: "Buscar información...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            GestureDetector(
              onTap: _isEditing ? _pickImage : null,
              child: CircleAvatar(
                radius: 70,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : const AssetImage(
                            "assets/images/profile_default.jpg")
                        as ImageProvider,
                child: _isEditing
                    ? const Icon(Icons.camera_alt,
                        size: 40, color: Colors.white70)
                    : null,
              ),
            ),

            const SizedBox(height: 16),

            if (_matchesSearch("$nombre $apellido"))
              Text(
                "$nombre $apellido",
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

            const SizedBox(height: 40),

            if (_matchesSearch(correo))
              _infoRow(Icons.email, "Correo", correo),

            if (_matchesSearch(documento))
              _infoRow(Icons.badge, "Documento", documento),

            if (_matchesSearch(_celularController.text))
              _isEditing
                  ? _editableField(
                      Icons.phone, "Celular", _celularController)
                  : _infoRow(
                      Icons.phone, "Celular", _celularController.text),

            if (_matchesSearch(fechaNacimiento))
              _infoRow(Icons.cake, "Nacimiento", fechaNacimiento),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() => _isEditing = !_isEditing);
                },
                icon: Icon(_isEditing ? Icons.save : Icons.edit),
                label:
                    Text(_isEditing ? "Guardar cambios" : "Editar perfil"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(color: Colors.grey)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _editableField(
      IconData icon, String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _celularController.dispose();
    super.dispose();
  }
}
