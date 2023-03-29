public interface IGroupMembersSelector extends fflib_ISObjectSelector {
    List<GroupMember> selectByGroupId(Set<Id> setIds);
}