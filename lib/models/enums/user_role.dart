enum UserRole {
  admin,
  agent,
  client,
  vendor
}

extension UserRoleExtension on UserRole {
  String get name {
    switch (this) {
      case UserRole.admin:
        return 'ADMIN';
      case UserRole.agent:
        return 'AGENT';
      case UserRole.client:
        return 'CLIENT';
      case UserRole.vendor:
        return 'VENDOR';
    }
  }

  // Méthode pour transformer un String en enum UserRole
  static UserRole fromString(String role) {
    switch (role.toUpperCase()) {
      case 'ADMIN':
        return UserRole.admin;
      case 'AGENT':
        return UserRole.agent;
      case 'CLIENT':
        return UserRole.client;
      case 'VENDOR':
        return UserRole.vendor;
      default:
        throw ArgumentError('Invalid UserRole value: $role');
    }
  }
}
