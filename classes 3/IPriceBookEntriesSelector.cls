public interface IPriceBookEntriesSelector extends fflib_ISObjectSelector {

    List<PriceBookEntry> selectById(Set<ID> idSet);
    List<PriceBookEntry> selectByIdWithCustomFields(Set<ID> idSet);
    List<PriceBookEntry> selectByPriceBookNameWithCustomFields(String priceBookName);
    List<PriceBookEntry> selectByPBNameAndCategoryWithCustomFields(String priceBookName, String category);
    List<PriceBookEntry> selectByProductCode (Set<String> codes, Integer recordLimit);
    List<PriceBookEntry> selectByProductCodeAndPriceBookId(Set<String> codes, Set<String> priceBookId);
    List<PriceBookEntry> selectByPriceBookNameAndProduct2Id (String priceBookName, Set<String> codes);
}