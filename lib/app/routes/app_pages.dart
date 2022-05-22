import 'package:get/get.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/form_menu/bindings/form_menu_binding.dart';
import '../modules/form_menu/views/form_menu_view.dart';
import '../modules/form_user/bindings/form_user_binding.dart';
import '../modules/form_user/views/form_user_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/index_menu/bindings/index_menu_binding.dart';
import '../modules/index_menu/views/index_menu_view.dart';
import '../modules/transaksi/bindings/transaksi_binding.dart';
import '../modules/transaksi/views/transaksi_view.dart';
import '../modules/users/bindings/users_binding.dart';
import '../modules/users/views/users_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.USERS,
      page: () => UsersView(),
      binding: UsersBinding(),
    ),
    GetPage(
      name: _Paths.FORM_USER,
      page: () => FormUserView(
        enableEdit: true,
      ),
      binding: FormUserBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_USER,
      page: () => FormUserView(
        enableEdit: false,
      ),
      binding: FormUserBinding(),
    ),
    GetPage(
      name: _Paths.INDEX_MENU,
      page: () => IndexMenuView(),
      binding: IndexMenuBinding(),
    ),
    GetPage(
      name: _Paths.FORM_MENU,
      page: () => FormMenuView(
        enableEdit: true,
      ),
      binding: FormMenuBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_MENU,
      page: () => FormMenuView(
        enableEdit: false,
      ),
      binding: FormMenuBinding(),
    ),
    GetPage(
      name: _Paths.TRANSAKSI,
      page: () => TransaksiView(),
      binding: TransaksiBinding(),
    ),
  ];
}
