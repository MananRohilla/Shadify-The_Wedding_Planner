import 'package:flutter/material.dart';
import '../../models/guest.dart';
import '../../services/guest_service.dart';

class AddGuestDialog extends StatefulWidget {
  final Guest? guest;

  const AddGuestDialog({super.key, this.guest});

  @override
  State<AddGuestDialog> createState() => _AddGuestDialogState();
}

class _AddGuestDialogState extends State<AddGuestDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dietaryController = TextEditingController();
  final _guestService = GuestService();

  bool _plusOne = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.guest != null) {
      _nameController.text = widget.guest!.name;
      _emailController.text = widget.guest!.email ?? '';
      _phoneController.text = widget.guest!.phone ?? '';
      _dietaryController.text = widget.guest!.dietaryRestrictions ?? '';
      _plusOne = widget.guest!.plusOne;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dietaryController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (widget.guest == null) {
        final newGuest = Guest(
          id: '',
          userId: '',
          name: _nameController.text.trim(),
          email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
          phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
          rsvpStatus: 'pending',
          plusOne: _plusOne,
          dietaryRestrictions: _dietaryController.text.trim().isEmpty ? null : _dietaryController.text.trim(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await _guestService.addGuest(newGuest);
      } else {
        await _guestService.updateGuest(
          widget.guest!.copyWith(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            plusOne: _plusOne,
            dietaryRestrictions: _dietaryController.text.trim(),
            updatedAt: DateTime.now(),
          ),
        );
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.guest == null ? 'Add Guest' : 'Edit Guest'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter guest name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dietaryController,
                decoration: const InputDecoration(
                  labelText: 'Dietary Restrictions (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.restaurant),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                value: _plusOne,
                onChanged: (value) {
                  setState(() => _plusOne = value ?? false);
                },
                title: const Text('Plus One'),
                subtitle: const Text('Guest can bring a companion'),
                contentPadding: EdgeInsets.zero,
                activeColor: const Color(0xFF4CAF50),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50),
            foregroundColor: Colors.white,
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}
