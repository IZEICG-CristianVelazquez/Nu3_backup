public class ProductosOrderItem {

    public String productId {get; set; }
    public String name  {get; set; }
    public String productCode {get; set; }
    public Decimal unitPrice {get; set; }
    public Decimal quantity {get; set; }

    public ProductosOrderItem (String productId, String name,String productCode, Decimal unitPrice, Integer quantity) {
        this.productId = productId;
        this.name = name;
        this.productCode = productCode;
        this.unitPrice = unitPrice.setScale(2);
        this.quantity = quantity;
    }

}