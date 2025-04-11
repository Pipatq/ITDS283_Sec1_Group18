import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../config.dart';

class AddNewsPage extends StatefulWidget {
  const AddNewsPage({super.key});

  @override
  State<AddNewsPage> createState() => _AddNewsPageState();
}

class _AddNewsPageState extends State<AddNewsPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController sportTypeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  File? _selectedImage;
  bool _isPicking = false;

  Future<void> _pickImage(BuildContext context) async {
    if (_isPicking) return;
    _isPicking = true;

    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          _selectedImage = File(picked.path);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image selected successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No image selected.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image pick error: $e")),
      );
    } finally {
      _isPicking = false;
    }
  }

  Future<void> _submitNews(BuildContext context) async {
    final uri = Uri.parse('${AppConfig.baseUrl}/add_news');
    final request = http.MultipartRequest('POST', uri);

    // ส่งเฉพาะ field ที่มีข้อมูล
    if (titleController.text.isNotEmpty) request.fields['title'] = titleController.text;
    if (sportTypeController.text.isNotEmpty) request.fields['sport_type'] = sportTypeController.text;
    if (descriptionController.text.isNotEmpty) request.fields['description'] = descriptionController.text;
    if (sourceController.text.isNotEmpty) request.fields['source'] = sourceController.text;
    if (phoneController.text.isNotEmpty) request.fields['contact_phone'] = phoneController.text;
    if (emailController.text.isNotEmpty) request.fields['contact_email'] = emailController.text;
    if (_selectedImage != null) {
      request.files.add(await http.MultipartFile.fromPath('image', _selectedImage!.path));
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("News submitted!")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to submit.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('News Feed', style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildTextField(titleController, 'Name of news'),
            _buildTextField(sportTypeController, 'Name of type of sports'),
            _buildTextField(descriptionController, 'Description', maxLines: 3),
            _buildTextField(sourceController, 'Source'),
            _buildTextField(phoneController, 'Contact Phone', keyboardType: TextInputType.phone),
            _buildTextField(emailController, 'Email', keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            const Text("Let’s talk about your idea", style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _pickImage(context),
              child: DottedBorderBox(selectedImage: _selectedImage),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _submitNews(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text('Submit', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const UnderlineInputBorder(),
        ),
      ),
    );
  }
}

class DottedBorderBox extends StatelessWidget {
  final File? selectedImage;

  const DottedBorderBox({super.key, this.selectedImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, style: BorderStyle.solid, width: 1),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade100,
      ),
      child: Center(
        child: selectedImage == null
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload_file, size: 32, color: Colors.blue),
                  SizedBox(height: 8),
                  Text("Drag your file here", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              )
            : Image.file(selectedImage!),
      ),
    );
  }
}
