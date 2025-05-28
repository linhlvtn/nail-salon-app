import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class AddReportScreen extends StatefulWidget {
  const AddReportScreen({super.key});

  @override
  _AddReportScreenState createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  File? _image;
  final _amountController = TextEditingController();
  String _paymentMethod = 'Chuyển khoản';
  String _service = 'Nail';
  final _noteController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  Future<void> _submitReport() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chụp ảnh')),
      );
      return;
    }
    final user = FirebaseAuth.instance.currentUser!;
    final ref = FirebaseStorage.instance.ref().child('reports/${DateTime.now().toString()}');
    await ref.putFile(_image!);
    final imageUrl = await ref.getDownloadURL();

    await FirebaseFirestore.instance.collection('reports').add({
      'userId': user.uid,
      'amount': _amountController.text,
      'paymentMethod': _paymentMethod,
      'service': _service,
      'note': _noteController.text,
      'image': imageUrl,
      'date': DateTime.now().toString(),
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm báo cáo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _image == null
                  ? ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Chụp ảnh'),
                    )
                  : Image.file(_image!, height: 200),
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Số tiền'),
                keyboardType: TextInputType.number,
              ),
              DropdownButton<String>(
                value: _paymentMethod,
                onChanged: (value) => setState(() => _paymentMethod = value!),
                items: ['Chuyển khoản', 'Tiền mặt'].map((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value));
                }).toList(),
              ),
              DropdownButton<String>(
                value: _service,
                onChanged: (value) => setState(() => _service = value!),
                items: ['Nail', 'Mi', 'Gội', 'Xăm'].map((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value));
                }).toList(),
              ),
              TextField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Ghi chú (không bắt buộc)'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitReport,
                child: const Text('Gửi báo cáo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}