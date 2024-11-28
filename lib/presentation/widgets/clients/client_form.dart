import 'package:flutter/material.dart';
import 'package:neetiflow/domain/entities/client.dart';

class ClientForm extends StatefulWidget {
  final Client? client;
  final ValueChanged<Client> onSubmit;

  const ClientForm({
    super.key,
    this.client,
    required this.onSubmit,
  });

  @override
  State<ClientForm> createState() => _ClientFormState();
}

class _ClientFormState extends State<ClientForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  
  // Basic Info Controllers
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  
  // Optional Info Controllers
  late final TextEditingController _websiteController;
  late final TextEditingController _gstinController;
  late final TextEditingController _panController;
  late final TextEditingController _organizationNameController;
  late final TextEditingController _governmentTypeController;
  
  // Dropdowns and Rating
  late ClientType _selectedType;
  late ClientStatus _selectedStatus;
  late ClientDomain _selectedDomain;
  late double _rating;

  @override
  void initState() {
    super.initState();
    final client = widget.client;
    
    // Initialize Basic Info Controllers
    _firstNameController = TextEditingController(text: client?.firstName);
    _lastNameController = TextEditingController(text: client?.lastName);
    _emailController = TextEditingController(text: client?.email);
    _phoneController = TextEditingController(text: client?.phone);
    _addressController = TextEditingController(text: client?.address);
    
    // Initialize Optional Info Controllers
    _websiteController = TextEditingController(text: client?.website);
    _gstinController = TextEditingController(text: client?.gstin);
    _panController = TextEditingController(text: client?.pan);
    _organizationNameController = TextEditingController(text: client?.organizationName);
    _governmentTypeController = TextEditingController(text: client?.governmentType);
    
    // Initialize Dropdowns and Rating
    _selectedType = client?.type ?? ClientType.individual;
    _selectedStatus = client?.status ?? ClientStatus.active;
    _selectedDomain = client?.domain ?? ClientDomain.other;
    _rating = client?.rating ?? 0;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _websiteController.dispose();
    _gstinController.dispose();
    _panController.dispose();
    _organizationNameController.dispose();
    _governmentTypeController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_isSubmitting) return; // Prevent double submission
      
      setState(() {
        _isSubmitting = true;
      });

      try {
        final client = Client(
          id: widget.client?.id ?? 'temp_${DateTime.now().millisecondsSinceEpoch}',
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
          type: _selectedType,
          status: _selectedStatus,
          domain: _selectedDomain,
          rating: _rating,
          organizationName: _selectedType == ClientType.company 
              ? _organizationNameController.text.trim() 
              : null,
          governmentType: _selectedType == ClientType.government 
              ? _governmentTypeController.text.trim() 
              : null,
          website: _websiteController.text.trim().isEmpty ? null : _websiteController.text.trim(),
          gstin: _gstinController.text.trim().isEmpty ? null : _gstinController.text.trim(),
          pan: _panController.text.trim().isEmpty ? null : _panController.text.trim(),
          leadId: widget.client?.leadId,
          joiningDate: widget.client?.joiningDate ?? DateTime.now(),
          lastInteractionDate: DateTime.now(),
          metadata: widget.client?.metadata ?? {},
          tags: widget.client?.tags ?? [],
          assignedEmployeeId: widget.client?.assignedEmployeeId,
          projects: widget.client?.projects ?? [],
          lifetimeValue: widget.client?.lifetimeValue ?? 0.0,
        );

        // Submit the form and close dialog immediately
        widget.onSubmit(client);
        Navigator.of(context).pop();
      } catch (e) {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error submitting form: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800, // Increased width for more fields
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.client == null ? 'Add Client' : 'Edit Client',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              
              // Client Type Selection
              DropdownButtonFormField<ClientType>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Client Type',
                  border: OutlineInputBorder(),
                ),
                items: ClientType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedType = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              
              // Basic Information
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter first name';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter last name';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Organization Name (for company type)
              if (_selectedType == ClientType.company)
                Column(
                  children: [
                    TextFormField(
                      controller: _organizationNameController,
                      decoration: const InputDecoration(
                        labelText: 'Organization Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (_selectedType == ClientType.company && 
                            (value == null || value.isEmpty)) {
                          return 'Please enter organization name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              
              // Government Type (for government type)
              if (_selectedType == ClientType.government)
                Column(
                  children: [
                    TextFormField(
                      controller: _governmentTypeController,
                      decoration: const InputDecoration(
                        labelText: 'Government Type (e.g., Federal - USA, State - California)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (_selectedType == ClientType.government && 
                            (value == null || value.isEmpty)) {
                          return 'Please enter government type';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              
              // Contact Information
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter phone number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Address
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              
              // Domain Selection
              DropdownButtonFormField<ClientDomain>(
                value: _selectedDomain,
                decoration: const InputDecoration(
                  labelText: 'Business Domain',
                  border: OutlineInputBorder(),
                ),
                items: ClientDomain.values.map((domain) {
                  return DropdownMenuItem(
                    value: domain,
                    child: Text(domain.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedDomain = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              
              // Client Rating
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Client Rating'),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          setState(() {
                            _rating = index + 1.0;
                          });
                        },
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Optional Information
              ExpansionTile(
                title: const Text('Additional Information'),
                children: [
                  TextFormField(
                    controller: _websiteController,
                    decoration: const InputDecoration(
                      labelText: 'Website (Optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _gstinController,
                          decoration: const InputDecoration(
                            labelText: 'GSTIN (Optional)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _panController,
                          decoration: const InputDecoration(
                            labelText: 'PAN (Optional)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Form Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitForm,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Text(widget.client == null ? 'Add' : 'Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
