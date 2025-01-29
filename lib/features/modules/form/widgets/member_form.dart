import 'package:flutter/material.dart';
import 'package:inventory_platform/data/models/member_model.dart';
import 'package:inventory_platform/data/models/user_model.dart';
import 'package:inventory_platform/data/repositories/member_repository.dart';
import 'package:inventory_platform/data/repositories/user_repository.dart';
import 'package:inventory_platform/features/common/widgets/custom_text_field.dart';

class MemberForm extends StatefulWidget {
  final bool? enabled;
  final dynamic initialData;
  final Color? labelColor;

  const MemberForm({
    super.key,
    this.enabled,
    this.initialData,
    this.labelColor,
  });

  @override
  MemberFormState createState() => MemberFormState();
}

class MemberFormState extends State<MemberForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _roleController = TextEditingController();

  final MemberRepository _memberRepository = MemberRepository();
  final UserRepository _userRepository = UserRepository();

  MemberModel get memberModel => MemberModel(
        id: _memberRepository.generateUniqueId(),
        user: UserModel(
          id: _userRepository.generateUniqueId(),
          name: _nameController.text,
          email: _emailController.text,
        ),
        role: _roleController.text,
        isActive: 1,
        createdAt: DateTime.now(),
        lastSeen: DateTime.now(),
      );

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  bool submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            label: 'Nome *',
            controller: _nameController,
            hint: 'Ex.: João Silva',
            validator: (value) =>
                value == null || value.isEmpty ? 'Nome é obrigatório' : null,
          ),
          const SizedBox(height: 10),
          CustomTextField(
            label: 'Email *',
            controller: _emailController,
            hint: 'Ex.: joao.silva@example.com',
            validator: (value) =>
                value == null || value.isEmpty ? 'Email é obrigatório' : null,
          ),
          const SizedBox(height: 10),
          CustomTextField(
            label: 'Função *',
            controller: _roleController,
            hint: 'Ex.: Administrador',
            validator: (value) =>
                value == null || value.isEmpty ? 'Função é obrigatória' : null,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
