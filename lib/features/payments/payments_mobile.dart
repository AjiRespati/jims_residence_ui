import 'package:flutter/material.dart';
import 'package:residenza/features/payments/components/create_expense_content.dart';
import 'package:residenza/features/payments/components/payment_list_mobile.dart';
import 'package:residenza/features/payments/components/payment_resume_mobile.dart';
import 'package:residenza/utils/helpers.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class PaymentsMobile extends StatefulWidget with GetItStatefulWidgetMixin {
  PaymentsMobile({super.key});

  @override
  State<PaymentsMobile> createState() => _PaymentsMobileState();
}

class _PaymentsMobileState extends State<PaymentsMobile>
    with GetItStateMixin, SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      // kalau index tidak berubah berarti swipe.
      if (!_tabController.indexIsChanging) {
        // get<StockViewModel>().stockTabIndex = _tabController.index;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    watchOnly((RoomViewModel x) => x.invoices);
    watchOnly((RoomViewModel x) => x.isError);
    watchOnly((RoomViewModel x) => x.isSuccess);
    if (mounted) {
      snackbarGenerator(context, get<RoomViewModel>());
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Transaksi"),
        bottom: TabBar(
          labelColor: Colors.blue.shade800,
          unselectedLabelColor: Colors.grey.shade600,
          controller: _tabController,
          indicatorColor: Colors.blue.shade700,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorWeight: 6,
          labelStyle: TextStyle(fontWeight: FontWeight.w600),
          tabs: [
            Tab(icon: Icon(Icons.list_alt), text: "List"),
            Tab(icon: Icon(Icons.note_add_outlined), text: "Resume"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [PaymentListMobile(), PaymentResumeMobile()],
      ),

      bottomNavigationBar: MobileNavbar(selectedindex: 3),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: SizedBox(
        height: 40,
        child: FloatingActionButton.extended(
          extendedPadding: EdgeInsets.symmetric(horizontal: 10),
          label: Text(
            "Pengeluaran",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          backgroundColor: const Color.fromARGB(200, 211, 47, 47),
          onPressed: () async {
            await showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: SingleChildScrollView(child: CreateExpenseContent()),
                );
              },
            );
          },
          icon: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
