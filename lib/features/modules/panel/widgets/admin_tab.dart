import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/core/services/mock_service.dart';
import 'package:inventory_platform/features/data/models/member_model.dart';
import 'package:inventory_platform/features/data/models/organization_model.dart';

class AdminTab extends StatefulWidget {
  const AdminTab({super.key});

  @override
  State<AdminTab> createState() => _AdminTabState();
}

class _AdminTabState extends State<AdminTab> {
  final OrganizationModel organization = Get.arguments;
  late final MockService mockService;
  List<MemberModel> _allMembers = [];

  @override
  void initState() {
    super.initState();
    mockService = Get.find<MockService>();
    _allMembers = mockService.getMembersForOrganization(organization.id)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(organization.title),
            const SizedBox(height: 8.0),
            _buildOrganizationInfoWidget(),
            const SizedBox(height: 16.0),
            _buildManageMembersWidget(),
            const SizedBox(height: 42.0),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String organizationName) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Painel do Administrador',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: Colors.greenAccent.shade700,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Text(
                organizationName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrganizationInfoWidget() {
    return Card(
      color: Colors.white,
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Informações da Organização",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16.0),
            _buildCustomTextField(
              initialValue: organization.title,
              labelText: "Nome da Organização",
            ),
            const SizedBox(height: 16.0),
            _buildCustomTextField(
              initialValue: organization.description,
              labelText: "Descrição",
              maxLines: 3,
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.image),
                    label: const Text(
                      "Alterar Banner",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {},
                    style: ButtonStyle(
                      iconColor: WidgetStateProperty.all(Colors.white),
                      backgroundColor:
                          WidgetStateProperty.all(Colors.blueAccent),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManageMembersWidget() {
    return Card(
      color: Colors.white,
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Gerenciar Membros",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16.0),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _allMembers.length,
              itemBuilder: (context, index) {
                final member = _allMembers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Text(
                      member.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(member.name),
                  subtitle: Text(member.role),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () {},
                  ),
                );
              },
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.person_add),
                label: const Text(
                  "Adicionar Membro",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {},
                style: ButtonStyle(
                  iconColor: WidgetStateProperty.all(Colors.white),
                  backgroundColor: WidgetStateProperty.all(Colors.blueAccent),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTextField({
    required String initialValue,
    required String labelText,
    int maxLines = 1,
  }) {
    return TextFormField(
      enabled: false,
      initialValue: initialValue,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
        ),
        floatingLabelStyle: const TextStyle(
          color: Colors.blueAccent,
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: Colors.blueAccent,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 2.0,
          ),
        ),
      ),
      style: const TextStyle(
        fontSize: 16.0,
        color: Colors.black87,
      ),
    );
  }
}
