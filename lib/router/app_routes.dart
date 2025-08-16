class AppRoutes {
  static const home = 'home';
  static const expenseNew = 'expenseNew';
  static const expenseEdit = 'expenseEdit';
}

class AppPaths {
  static const home = '/';
  static const expenseNew = '/expense/new';
  static String expenseEdit(String id) => '/expense/$id/edit';
}
