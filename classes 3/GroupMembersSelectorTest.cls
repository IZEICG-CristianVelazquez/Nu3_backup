@IsTest
public class GroupMembersSelectorTest {
    @IsTest
    static void whenSelectByGroupIdReturnRecords(){
        Id groupId = fflib_IDGenerator.generate(GroupMember.SObjectType);
        GroupMembersSelector.newInstance().selectByGroupId(new Set<Id>{groupId});

    }
}