enum GenderType {
  Male(1),
  Female(2);

  final int value;
  const GenderType(this.value);
}

extension GenderTypeOnString on String {
  GenderType get toGenderType {
    switch (toLowerCase()) {
      case 'male':
        return GenderType.Male;
      case 'female':
        return GenderType.Female;
    }
    return GenderType.Male;
  }
}
