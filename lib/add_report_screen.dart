import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class AddReportScreen extends StatefulWidget {
  final String? reportId;
  final Map<String, dynamic>? initialData;

  const AddReportScreen({super.key, this.reportId, this.initialData});

  @override
  _AddReportScreenState createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  File? _image;
  final _amountController = TextEditingController();
  String _paymentMethod = 'Chuyển khoản';
  String _service = 'Nail';
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _amountController.text = widget.initialData!['amount'] ?? '';
      _paymentMethod = widget.initialData!['paymentMethod'] ?? 'Chuyển khoản';
      _service = widget.initialData!['service'] ?? 'Nail';
      _noteController.text = widget.initialData!['note'] ?? '';
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  Future<void> _submitReport() async {
    if (_image == null && widget.initialData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chụp ảnh')),
      );
      return;
    }
    final user = FirebaseAuth.instance.currentUser!;
    String? imageUrl = widget.initialData?['image'];

    if (_image != null) {
      final ref = FirebaseStorage.instance.ref().child('reports/${DateTime.now().toString()}');
      await ref.putFile(_image!);
      imageUrl = await ref.getDownloadURL();
    }

    final data = {
      'userId': user.uid,
      'amount': _amountController.text,
      'paymentMethod': _paymentMethod,
      'service': _service,
      'note': _noteController.text,
      'image': imageUrl,
      'date': DateTime.now().toString(),
    };

    if (widget.reportId != null) {
      await FirebaseFirestore.instance.collection('reports').doc(widget.reportId).update(data);
    } else {
      await FirebaseFirestore.instance.collection('reports').add(data);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.reportId != null ? 'Chỉnh sửa báo cáo' : 'Thêm báo cáo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              widget.initialData?['image'] != null && _image == null
                  ? Image.network(widget.initialData!['image'], height: 200)
                  : _image != null
                      ? Image.file(_image!, height: 200)
                      : ElevatedButton(
                          onPressed: _pickImage,
                          child: const Text('Chụp ảnh'),
                        ),
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
                child: Text(widget.reportId != null ? 'Cập nhật báo cáo' : 'Gửi báo cáo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}