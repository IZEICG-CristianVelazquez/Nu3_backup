public interface IOrdersSelector extends fflib_ISObjectSelector {

    List<Order> selectById(Set<ID> idSet);
    List<Order> selectByIdWithAccountInfo (Set<ID> idSet);
    List<Order> selectByExternalId(Set<String> idSet);
    List<Order> selectByIdWithProducts (Set<ID> idSet);
    List<Order> selectByExternalIdWithProducts (Set<String> idSet);
    List<Order> selectRecentlyUpdatedWithOrderItems (Integer recordLimit);
}