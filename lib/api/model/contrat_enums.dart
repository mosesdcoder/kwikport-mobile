enum ContractCategory {
  Agriculture,
  Cosmetics,
  Textile,
  Construction,
  Other,
}

extension ContractCategoryExtension on ContractCategory {
  int get value {
    switch (this) {
      case ContractCategory.Agriculture:
        return 1;
      case ContractCategory.Cosmetics:
        return 2;
      case ContractCategory.Textile:
        return 3;
      case ContractCategory.Construction:
        return 4;
      case ContractCategory.Other:
        return 5;
    }
  }

  String get name {
    switch (this) {
      case ContractCategory.Agriculture:
        return "Agriculture";
      case ContractCategory.Cosmetics:
        return "Cosmetics";
      case ContractCategory.Textile:
        return "Textile";
      case ContractCategory.Construction:
        return "Construction";
      case ContractCategory.Other:
        return "Other";
    }
  }
}
