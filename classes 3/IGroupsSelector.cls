public interface IGroupsSelector extends fflib_ISObjectSelector{
    List<Group> selectByDevName(Set<String> setNames);
}