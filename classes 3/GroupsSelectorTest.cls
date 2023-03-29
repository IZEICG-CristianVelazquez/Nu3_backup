@IsTest
public class GroupsSelectorTest {
    @IsTest
    static void whenSelectByDevNamereturnRecords(){
        
        GroupsSelector.newInstance().selectByDevName(new Set<String>{'test'});
        
    }
}