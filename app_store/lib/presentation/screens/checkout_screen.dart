import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_core/l10n/app_localizations.dart';
import 'package:shop_core/shop_core.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../bloc/cart/cart_state.dart';
import '../widgets/home_appbar.dart';
import '../widgets/textfile.dart';

class CheckoutScreen extends StatefulWidget {
  final int totalAmount;
  const CheckoutScreen({super.key, required this.totalAmount});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  String _formatPrice(int price) {
    return '${price.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},")}đ';
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xffFFF8F0),
      appBar: const HomeAppbar(
        title: 'Xác nhận đơn hàng',
        showBackButton: true,
      ),
      body: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartSuccess) {
            SnackbarUtils.showSuccess(
              context,
              'Đặt hàng thành công!',
              language,
            );
            context.go('/home');
          } else if (state is CartError) {
            SnackbarUtils.showError(context, state.message, language);
          }
        },
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(
                      Icons.location_on_outlined,
                      'Địa chỉ nhận hàng',
                    ),
                    const SizedBox(height: 12),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Textfile(
                              labelText: 'Họ và tên người nhận',
                              icon: const Icon(Icons.person_outline),
                              controller: _nameController,
                            ),
                            const SizedBox(height: 16),
                            Textfile(
                              labelText: 'Số điện thoại',
                              icon: const Icon(Icons.phone_android_outlined),
                              controller: _phoneController,
                            ),
                            const SizedBox(height: 16),
                            Textfile(
                              labelText:
                                  'Địa chỉ chi tiết (Số nhà, tên đường...)',
                              icon: const Icon(Icons.map_outlined),
                              controller: _addressController,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle(
                      Icons.payment_outlined,
                      'Phương thức thanh toán',
                    ),
                    const SizedBox(height: 12),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.money, color: Colors.green),
                        title: const Text('Thanh toán khi nhận hàng (COD)'),
                        trailing: Icon(
                          Icons.check_circle,
                          color: Color(0xff7F5539),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildBottomAction(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xff7F5539), size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xff3E2C24),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        20,
      ).copyWith(bottom: MediaQuery.of(context).padding.bottom + 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tổng thanh toán',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                Text(
                  _formatPrice(widget.totalAmount),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff7F5539),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: () {
                if (_nameController.text.trim().isEmpty ||
                    _addressController.text.trim().isEmpty) {
                  SnackbarUtils.showError(
                    context,
                    'Vui lòng nhập địa chỉ giao hàng',
                    AppLocalizations.of(context),
                  );
                  return;
                }

                final address = AddressModel(
                  fullName: _nameController.text.trim(),
                  phoneNumber: _phoneController.text.trim(),
                  detailAddress: _addressController.text.trim(),
                );

                context.read<CartBloc>().add(
                  CheckoutCart(
                    totalAmount: widget.totalAmount,
                    address: address,
                  ),
                );
              },
              child: const Text(
                'ĐẶT HÀNG',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
