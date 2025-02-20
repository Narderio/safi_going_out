enum Role { ADMIN, USER }

extension UserRoleExtension on Role {
  static Role fromString(String role) {
    return Role.values.firstWhere(
          (e) => e.name.toUpperCase() == role.toUpperCase(),
      orElse: () => Role.USER, // Ruolo di default
    );
  }
}