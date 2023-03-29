public interface IPermissionSetAssignmentsSelector extends fflib_ISObjectSelector {
    List<PermissionSetAssignment> selectByAssigneeIdWithPermissionSet(Set<Id> setIds);
}