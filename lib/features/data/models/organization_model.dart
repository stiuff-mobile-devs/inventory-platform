import 'package:inventory_platform/features/data/models/domain_model.dart';
import 'package:inventory_platform/features/data/models/entity_model.dart';
import 'package:inventory_platform/features/data/models/inventory_model.dart';
import 'package:inventory_platform/features/data/models/member_model.dart';
import 'package:inventory_platform/features/data/models/reader_model.dart';
import 'package:inventory_platform/features/data/models/tag_model.dart';

class OrganizationModel {
  final String id;
  final String title;
  final String? description;
  final String? imagePath;

  List<MemberModel>? members;
  List<ReaderModel>? readers;
  List<EntityModel>? entities;
  List<TagModel>? tags;
  List<InventoryModel>? inventories;
  List<DomainModel>? domains;

  OrganizationModel({
    required this.id,
    required this.title,
    this.description,
    this.imagePath,
  })  : members = [],
        readers = [],
        entities = [],
        tags = [],
        inventories = [],
        domains = [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imagePath': imagePath,
    };
  }

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imagePath: json['imagePath'] as String,
    );
  }
}
