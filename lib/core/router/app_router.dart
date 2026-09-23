import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/providers/auth_notifier.dart';
import '../../features/customer/presentation/pages/customer_test_page.dart';
import '../../features/establishment/presentation/pages/establishment_form_page.dart';
import '../../features/establishment/presentation/pages/profile_page.dart';
import '../../features/home/presentation/page/home_page.dart';
import '../../features/invoices/presentation/pages/invoice_form_page.dart';
import '../../features/invoices/presentation/pages/invoices_page.dart';
import '../../features/products/presentation/pages/product_form_page.dart';
import '../../features/products/presentation/pages/products_page.dart';

class AppRoutes {
  static const login = '/login';
  static const home = '/home';
  static const profile = '/profile';
  static const establishmentForm = '/establishment/form';
  static const customerSearch = '/customer/search';
  static const products = '/products';
  static const productForm = '/products/form';
  static const invoices = '/invoices';
  static const invoiceForm = '/invoices/form';
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.login,
    redirect: (context, state) {
      final isLoggedIn = authState.auth != null;
      final isLoggingIn = state.matchedLocation == AppRoutes.login;

      if (!isLoggedIn && !isLoggingIn) {
        return AppRoutes.login;
      }

      if (isLoggedIn && isLoggingIn) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.establishmentForm,
        builder: (context, state) => const EstablishmentFormPage(),
      ),
      GoRoute(
        path: AppRoutes.customerSearch,
        builder: (context, state) => const CustomerTestPage(),
      ),
      GoRoute(
        path: AppRoutes.products,
        builder: (context, state) => const ProductsPage(),
      ),
      GoRoute(
        path: AppRoutes.productForm,
        builder: (context, state) => const ProductFormPage(),
      ),
      GoRoute(
        path: AppRoutes.invoices,
        builder: (context, state) => const InvoicesPage(),
      ),
      GoRoute(
        path: AppRoutes.invoiceForm,
        builder: (context, state) => const InvoiceFormPage(),
      ),
    ],
  );
});
