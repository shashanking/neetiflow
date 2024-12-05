import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/domain/entities/employee.dart';
import 'package:neetiflow/domain/entities/organization.dart';
import 'package:neetiflow/domain/entities/role.dart';
import 'package:neetiflow/presentation/blocs/auth/auth_bloc.dart';
import 'package:neetiflow/presentation/widgets/persistent_shell.dart';

class RegisterOrganizationPage extends StatefulWidget {
  const RegisterOrganizationPage({super.key});

  @override
  State<RegisterOrganizationPage> createState() => _RegisterOrganizationPageState();
}

class _RegisterOrganizationPageState extends State<RegisterOrganizationPage> {
  final _formKey = GlobalKey<FormState>();
  final _organizationNameController = TextEditingController();
  final _organizationAddressController = TextEditingController();
  final _organizationPhoneController = TextEditingController();
  final _organizationEmailController = TextEditingController();
  final _organizationWebsiteController = TextEditingController();
  final _organizationPanController = TextEditingController();
  final _organizationGstinController = TextEditingController();
  final _adminFirstNameController = TextEditingController();
  final _adminLastNameController = TextEditingController();
  final _adminPhoneController = TextEditingController();
  final _adminEmailController = TextEditingController();
  final _adminAddressController = TextEditingController();
  final _adminPasswordController = TextEditingController();
  bool _isPasswordVisible = false;

  Role _createAdminRole(String organizationId) {
    return Role(
      id: 'admin_role_id', // Explicitly set ID
      name: 'Admin',
      description: 'Organization Administrator',
      organizationId: organizationId,
      type: RoleType.system,
      hierarchy: DepartmentHierarchy.admin,
      permissions: const [
        'full_access',
        'manage_users',
        'manage_organization',
        'view_all_data'
      ]
    );
  }

  void _registerOrganization() async {
    if (_formKey.currentState!.validate()) {
      try {
        final organization = Organization(
          name: _organizationNameController.text.trim(),
          email: _organizationEmailController.text.trim(),
          phone: _organizationPhoneController.text.trim(),
          address: _organizationAddressController.text.trim(),
        );

        final admin = Employee(
          firstName: _adminFirstNameController.text.trim(),
          lastName: _adminLastNameController.text.trim(),
          email: _adminEmailController.text.trim(),
          phone: _adminPhoneController.text.trim(),
          address: _adminAddressController.text.trim(),
          role: _createAdminRole(''), // Temporary ID, will be set by repository
          isActive: true,
          joiningDate: DateTime.now(),
        );

        context.read<AuthBloc>().add(
          CreateOrganizationRequested(
            organization: organization,
            admin: admin,
            password: _adminPasswordController.text.trim(),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _organizationNameController.dispose();
    _organizationAddressController.dispose();
    _organizationPhoneController.dispose();
    _organizationEmailController.dispose();
    _organizationWebsiteController.dispose();
    _organizationPanController.dispose();
    _organizationGstinController.dispose();
    _adminFirstNameController.dispose();
    _adminLastNameController.dispose();
    _adminPhoneController.dispose();
    _adminEmailController.dispose();
    _adminAddressController.dispose();
    _adminPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('Register Organization'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is Authenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const PersistentShell()),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Organization Details',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _organizationNameController,
                            decoration: const InputDecoration(
                              labelText: 'Organization Name',
                              prefixIcon: Icon(Icons.business),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter organization name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _organizationAddressController,
                            decoration: const InputDecoration(
                              labelText: 'Address',
                              prefixIcon: Icon(Icons.location_on),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _organizationPhoneController,
                                  decoration: const InputDecoration(
                                    labelText: 'Phone',
                                    prefixIcon: Icon(Icons.phone),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter phone';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _organizationEmailController,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    prefixIcon: Icon(Icons.email),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter email';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _organizationWebsiteController,
                            decoration: const InputDecoration(
                              labelText: 'Website',
                              prefixIcon: Icon(Icons.web),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _organizationPanController,
                                  decoration: const InputDecoration(
                                    labelText: 'PAN',
                                    prefixIcon: Icon(Icons.credit_card),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _organizationGstinController,
                                  decoration: const InputDecoration(
                                    labelText: 'GSTIN',
                                    prefixIcon: Icon(Icons.receipt),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Admin Details',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _adminFirstNameController,
                          decoration: const InputDecoration(
                            labelText: 'First Name',
                            hintText: 'Enter your first name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your first name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _adminLastNameController,
                          decoration: const InputDecoration(
                            labelText: 'Last Name',
                            hintText: 'Enter your last name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your last name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _adminPhoneController,
                                decoration: const InputDecoration(
                                  labelText: 'Phone',
                                  prefixIcon: Icon(Icons.phone),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter phone';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _adminEmailController,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter email';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _adminAddressController,
                          decoration: const InputDecoration(
                            labelText: 'Address',
                            prefixIcon: Icon(Icons.location_on),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _adminPasswordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return FilledButton(
                      onPressed: state is AuthLoading ? null : _registerOrganization,
                      child: state is AuthLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Register'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
