public interface IProductsSelector extends fflib_ISObjectSelector {
    List<Product2> selectById(Set<ID> idSet);
    List<Product2> selectByProductCode(Set<String> productCode, Integer recordLimit);

}