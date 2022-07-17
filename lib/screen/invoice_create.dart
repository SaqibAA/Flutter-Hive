import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:invoice_generater/screen/global/global.dart';
// import 'package:invoice_generater/screen/invoice/file_handle_api.dart';
// import 'package:invoice_generater/screen/invoice/pdf_invoice_api.dart';
import 'package:invoice_generater/screen/invoice_details.dart';

class CreateInvoice extends StatefulWidget {
  int key_value;
  CreateInvoice({Key? key, required this.key_value}) : super(key: key);

  @override
  State<CreateInvoice> createState() => CreateInvoiceState();
}

List ItemLIist = [];
String name = '';
String address = '';
double Total_Amount = 0.0;

class CreateInvoiceState extends State<CreateInvoice> {
  @override
  void initState() {
    super.initState();
    ItemLIist = [];
    Total_Amount = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box("invoice");

    // Add Item
    Future<void> AddItem(Map<String, dynamic> newItem) async {
      await box.add(newItem);
      print(newItem);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  InvoiceDetails(item_key: widget.key_value)));
      // refreshData(); // update the UI
    }

    final customer_name = TextEditingController();
    final customer_address = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Create Invoice"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: app_color,
        onPressed: () async {
          // FocusScope.of(context).unfocus();
          showForm();
        },
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            // FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                child: TextField(
                  controller: customer_name,
                  decoration: InputDecoration(
                      hintText: "Customer Name",
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0)),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 15),
                child: TextField(
                  controller: customer_address,
                  decoration: InputDecoration(
                      hintText: "Customer Address",
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0)),
                ),
              ),
              FittedBox(
                child: ItemLIist.isEmpty
                    ? Center(
                        child: Text("No Item Add in List"),
                      )
                    : DataTable(
                        columns: [
                          DataColumn(
                              label: Text('Sr No.',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Item Name',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Quantity',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Price',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Total',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold))),
                        ],
                        rows: List.generate(
                          ItemLIist.length,
                          (index) => DataRow(cells: [
                            DataCell(
                              Text("${index + 1}"),
                            ),
                            DataCell(
                              Text(ItemLIist[index]['item_name']),
                            ),
                            DataCell(
                              Text(ItemLIist[index]['item_quantity']),
                            ),
                            DataCell(
                              Text(
                                  "${double.parse(ItemLIist[index]['item_price'])}"),
                            ),
                            DataCell(
                              Text(ItemLIist[index]['item_total']),
                            ),
                          ]),
                        ).toList(),
                      ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(right: 20),
                alignment: Alignment.centerRight,
                child: Text("Total : ₹ $Total_Amount",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (customer_name.text != "" &&
                        customer_address.text != "") {
                      AddItem(
                        {
                          'name': customer_name.text,
                          'date': DateFormat('dd-MM-yy').format(DateTime.now()),
                          'time': DateFormat('HH:mm:ss').format(DateTime.now()),
                          'address': customer_address.text,
                          'items': ItemLIist,
                          'total': Total_Amount,
                        },
                      );
                      print(customer_name.text);
                      print(customer_address.text);
                    } else {
                      Fluttertoast.showToast(msg: "Enter Name or Address");
                    }
                  },
                  child: Text("Generate Invoice"))
            ],
          ),
        ),
      ),
    );
  }

  showForm() {
    TextEditingController item_name = TextEditingController();
    TextEditingController item_quantity = TextEditingController();
    TextEditingController item_price = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // title: Text('Add Product Details'),
          content: Container(
              alignment: Alignment.center,
              height: 280,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Add Product Details',
                          style: TextStyle(
                            fontSize: 16,
                          )),
                      Spacer(),
                      // Spacer(),
                      IconButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.clear_outlined)),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, top: 0, right: 10),
                    child: TextField(
                      controller: item_name,
                      decoration: InputDecoration(hintText: "Name"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: item_quantity,
                      decoration: InputDecoration(hintText: "Quantity in KG"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 10, top: 10, right: 10, bottom: 15),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: item_price,
                      decoration: InputDecoration(hintText: "Price"),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (item_name.text != "" &&
                            item_quantity != "" &&
                            item_price.text != "") {
                          setState(() {
                            Map<String, String> data = {
                              'item_quantity': "${item_quantity.text} Kg",
                              'item_price': item_price.text,
                              'item_name': item_name.text,
                              'item_total':
                                  "${double.parse(item_quantity.text) * double.parse(item_price.text)}",
                            };

                            ItemLIist.add(data);
                            Total_Amount = Total_Amount +
                                double.parse(
                                    "${double.parse(item_quantity.text) * double.parse(item_price.text)}");
                            print(ItemLIist);
                            Navigator.pop(context);
                          });
                        } else {
                          Fluttertoast.showToast(msg: "Enter All Details");
                        }
                      },
                      child: Text("ADD"))
                ],
              )

              // actions: <Widget>[
              //   new FlatButton(
              //     child: new Text('SUBMIT'),
              //     onPressed: () {
              //       Navigator.of(context).pop();
              //     },
              //   )
              // ],
              ),
        );
      },
    );
  }
}
