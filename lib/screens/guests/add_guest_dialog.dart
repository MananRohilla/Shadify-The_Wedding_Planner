import 'package:flutter/material.dart';
import '../../models/guest.dart';
import '../../services/guest_service.dart';
import '../../services/offline_service.dart';

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
  String _selectedRSVP = 'pending';
  bool _isLoading = false;

  final List<String> _rsvpOptions = ['pending', 'confirmed', 'declined'];

  @override
  void initState() {
    super.initState();
    if (widget.guest != null) {
      _nameController.text = widget.guest!.name;
      _emailController.text = widget.guest!.email ?? '';
      _phoneController.text = widget.guest!.phone ?? '';
      _dietaryController.text = widget.guest!.dietaryRestrictions ?? '';
      _plusOne = widget.guest!.plusOne;
      _selectedRSVP = widget.guest!.rsvpStatus.toLowerCase();
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
        // Create new guest
        final newGuest = Guest(
          id: '',
          userId: MockAuthService.currentUserEmail ?? 'demo',
          name: _nameController.text.trim(),
          email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
          phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
          rsvpStatus: _selectedRSVP,
          plusOne: _plusOne,
          dietaryRestrictions: _dietaryController.text.trim().isEmpty ? null : _dietaryController.text.trim(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await _guestService.addGuest(newGuest);
      } else {
        // Update existing guest
        final updatedGuest = widget.guest!.copyWith(
          name: _nameController.text.trim(),
          email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
          phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
          rsvpStatus: _selectedRSVP,
          plusOne: _plusOne,
          dietaryRestrictions: _dietaryController.text.trim().isEmpty ? null : _dietaryController.text.trim(),
          updatedAt: DateTime.now(),
        );
        await _guestService.updateGuest(updatedGuest);
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
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRSVP,
                decoration: const InputDecoration(
                  labelText: 'RSVP Status',
                  border: OutlineInputBorder(),
                ),
                items: _rsvpOptions.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedRSVP = value!);
                },
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Plus One'),
                value: _plusOne,
                onChanged: (value) {
                  setState(() => _plusOne = value ?? false);
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dietaryController,
                decoration: const InputDecoration(
                  labelText: 'Dietary Restrictions',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE91E63),
            foregroundColor: Colors.white,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.guest == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }
}
