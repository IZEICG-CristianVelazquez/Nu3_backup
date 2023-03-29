public interface IAccountsSelector extends fflib_ISObjectSelector {

    List<Account> selectById(Set<ID> idSet);
    List<Account> selectByExternalId(Set<String> externalIds, Integer recordLimit);
    List<Account> selectRecentlyUpdated(Integer recordLimit);
}