import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class Category with ChangeNotifier, DiagnosticableTreeMixin {
  String _category = 'All';

  String get category => _category;

  void changeCategory(category) {
    _category = category;
    notifyListeners();
  }
}
