import 'package:inventory_platform/data/models/reader_model.dart';

class ReaderRepository {
  final List<ReaderModel> _readers = [];

  List<ReaderModel> getAllReaders() {
    return _readers;
  }

  ReaderModel? getReaderById(String id) {
    return _readers.firstWhere((reader) => reader.mac == id);
  }

  void addReader(ReaderModel reader) {
    _readers.add(reader);
  }

  void updateReader(ReaderModel updatedReader) {
    final index =
        _readers.indexWhere((reader) => reader.mac == updatedReader.mac);
    if (index != -1) {
      _readers[index] = updatedReader;
    }
  }

  void deleteReader(String id) {
    _readers.removeWhere((reader) => reader.mac == id);
  }
}
