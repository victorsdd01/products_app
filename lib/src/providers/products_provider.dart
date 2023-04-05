import 'package:productos_app/src/ui/pages/pages.dart';

class ProductsProvider extends ChangeNotifier{

  GlobalKey<FormState> productsFormKey =  GlobalKey<FormState>();
    
  bool _isAvailable = false;
  bool isEnablePrice = false;
  String producName   = '';
  String producPrice  = '';
  String productDescription = '';
  bool autoFocusProducName = true;
  bool disableButtom = false;
  bool updateBottomDisabled = true;
  bool onClosingAlert = false;

  FocusNode productNamefn = FocusNode();
  FocusNode productPricefn = FocusNode();
  FocusNode productDescriptionfn = FocusNode();


  bool get isAvailable => _isAvailable;
  String get getProductName => producName;
  String get getProductPrice => producPrice;
  String get getProducDescription => productDescription;
  bool get getIsEnablePrice => isEnablePrice;
  bool get getAutoFocus => autoFocusProducName;
  bool get getOnClosingAlertValue => onClosingAlert;


  set setProducPrice(String value){
    producPrice = value;
    notifyListeners();
  }

  set setProductName(String value){
    producName = value;
    notifyListeners();
  }

  set setProductDescription(String value){
    productDescription = value;
    notifyListeners();
  }

  set setIsAvailableSet(bool value){
    _isAvailable = value;
    notifyListeners();
  }

  set setIsEnablePrice(bool value){
    isEnablePrice = value;
    notifyListeners();
  }

  set setAutoFocus(bool value){
    autoFocusProducName = value;
    notifyListeners();
  }

  set setDisableButtom(bool value){
    disableButtom = value;
    notifyListeners();
  }

  setUpdateBottomDisabled(bool value){
    updateBottomDisabled =  value;
    notifyListeners();
  }

  set setOnClosingAlertValue(bool value){
    onClosingAlert = value;
    notifyListeners();
  }

  bool validForm(){
    return productsFormKey.currentState?.validate() ?? false;
  }

  void clearState(){
    // clear the state when a product is added...
    setProductName = '';
    setProducPrice = '';
    setIsAvailableSet = false;
  }
}