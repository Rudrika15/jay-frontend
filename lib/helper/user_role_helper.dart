bool isAdminUser(String? userRole) {
  final userType = userRole;
  if (userType != null) {
   return (userType.trim().toLowerCase() == 'admin')
        ? true
        : false;
  } else {
    return false;
  }
}

bool isClientUser(String? userRole) {
  final userType = userRole;
  if (userType != null) {
    return (userType.trim().toLowerCase() == 'client')
        ? true
        : false;
  } else {
    return false;
  }
}
bool isNormalUser(String? userRole) {
  final userType = userRole;
  if (userType != null) {
    return (userType.trim().toLowerCase() == 'user')
        ? true
        : false;
  } else {
    return false;
  }
}