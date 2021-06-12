import 'package:flutter/material.dart';
import '../Provider/product.dart';
import 'package:provider/provider.dart';
import '../Provider/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routName = '/editProduct';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageURLControler = TextEditingController();
  final _imageURLFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, price: 0, title: "", description: "", imageUrl: "",isFavourite: false);
  var _isInt = true;
  var _initval = {'title': '', 'price': '', 'description': '', 'imageUrl': ''};
  var _isLoading = false;

  @override
  void didChangeDependencies() async {
    //to extract id from  argument can't extract on initstate because it come from Navigator if any type date we extract on initstate
    if (_isInt) {
      final productid = ModalRoute.of(context).settings.arguments as String;

      _editedProduct =
          Provider.of<Products>(context, listen: false).findById(productid);
      var _initval = {
        'title': _editedProduct.title,
        'price': _editedProduct.price.toString(),
        'description': _editedProduct.description,
//        'imageURL': _editedProduct.imageUrl
        'imageUrl': '',
        'isFavourite':false
      };
      _imageURLControler.text = _editedProduct.imageUrl;
    }
    _isInt = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    var _formValid = _form.currentState.validate();
    if (!_formValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
//
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("an error occurred"),
                  content: Text('something went wrong!'),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Okay!"))
                  ],
                ));
      }
//      finally {
//        setState(() {
//          _isLoading = false;
//        });
//        Navigator.of(context).pop();
//      } //it is return future

      //because all method add await can put set state in end method

    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  //we initial new product with id null
  //it used but there don't work

  @override
  void initState() {
    _imageURLFocusNode.addListener(_updateImageURL);
    super.initState();
  }

  @override
  void dispose() {
    _imageURLFocusNode.removeListener(_updateImageURL);
    //when we click on screen after add URL we can see photo .
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageURLControler.dispose();
    super.dispose();
  }

  _updateImageURL() {
    if (!_imageURLFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    Column(
                      children: [
                        TextFormField(
                          initialValue: _initval['title'],

                          validator: (value) {
                            if (value.isEmpty) {
                              return "please provided ";
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: 'title'),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(
                                _priceFocusNode); //when click go to focus node to price
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                                title: value,
                                imageUrl: _editedProduct.imageUrl,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                id: _editedProduct.id,
                                isFavourite: _editedProduct.isFavourite);
                          }, //when click on button
                        ),
                        TextFormField(
                            initialValue: _initval['price'],
                            decoration: InputDecoration(labelText: 'Price'),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            focusNode: _priceFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(
                                  _descriptionFocusNode); //when click go to focus node to price
                            },
                            validator: (value) {
                              if (value == null) {
                                return "please enter a number";
                              } 
                              if (double.tryParse(value) == null) {
                                return "please enter number valid";
                              }
                              if (double.parse(value) <= 0) {
                                return "please enter number get from Zero";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                  title: _editedProduct.title,
                                  imageUrl: _editedProduct.imageUrl,
                                  description: _editedProduct.description,
                                  price: double.parse(value),
                                  id: _editedProduct.id,
                                  isFavourite: _editedProduct.isFavourite);
                            }),
                        TextFormField(
                          initialValue: _initval['description'],

                          decoration: InputDecoration(labelText: 'description'),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          //it's given keyboard good for many line
                          focusNode: _descriptionFocusNode,
                          onSaved: (value) {
                            _editedProduct = Product(
                                title: _editedProduct.title,
                                imageUrl: _editedProduct.imageUrl,
                                description: value,
                                price: _editedProduct.price,
                                id: _editedProduct.id,
                                isFavourite: _editedProduct.isFavourite);
                          },
                          validator: (value) {
                            if (value.isEmpty)
                              return "please enter description";
                            if (value.length < 10)
                              return "should be at 10 characters long";
                            return null;
                          },
                          //when click on button
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 10, top: 8),
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                              ),
                              child: _imageURLControler.text.isEmpty
                                  ? Text('enter Url')
                                  : FittedBox(
                                      child: Image.network(
                                        _imageURLControler.text,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            //he is take all width limit so we add expanded
                            Expanded(
                              child: TextFormField(
//                            initialValue: _initval['imageURL'],//can't use initial with controller
                                  decoration:
                                      InputDecoration(labelText: 'Image URL'),
                                  keyboardType: TextInputType.url,
                                  controller: _imageURLControler,
                                  textInputAction: TextInputAction.done,
                                  focusNode: _imageURLFocusNode,
                                  onFieldSubmitted: (_) {
                                    _saveForm();
                                    //he is function with (parameter String
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "please enter Image URL";
                                    }

                                    if (!value.startsWith("http") &&
                                        !value.startsWith("https")) {
                                      return "please enter valid URL";
                                    }
                                    if (!value.endsWith('.png') &&
                                        !value.endsWith('.jpg') &&
                                        !value.endsWith('.jpeg')) {
                                      return "please enter valid image  URL";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _editedProduct = Product(
                                        title: _editedProduct.title,
                                        imageUrl: value,
                                        description: _editedProduct.description,
                                        price: _editedProduct.price,
                                        id: _editedProduct.id,
                                      isFavourite: _editedProduct.isFavourite
                                       );
                                  }),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
