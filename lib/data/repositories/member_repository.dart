import 'package:inventory_platform/data/models/member_model.dart';
import 'package:uuid/uuid.dart';

class MemberRepository {
  final List<MemberModel> _members = [];

  List<MemberModel> getAllMembers() {
    return _members;
  }

  MemberModel? getMemberById(String id) {
    return _members.firstWhere((member) => member.id == id);
  }

  void addMember(MemberModel member) {
    _members.add(member);
  }

  void updateMember(MemberModel updatedMember) {
    final index =
        _members.indexWhere((reader) => reader.id == updatedMember.id);
    if (index != -1) {
      _members[index] = updatedMember;
    }
  }

  void deleteMember(String id) {
    _members.removeWhere((member) => member.id == id);
  }

  String generateUniqueId() {
    var uuid = const Uuid();
    String id;
    do {
      id = uuid.v4();
    } while (_members.any((member) => member.id == id));
    return id;
  }
}
