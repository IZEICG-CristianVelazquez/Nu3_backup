@IsTest
public class FacturasSchedulerTest {
    static String CRON_EXP = '0 0 0 15 3 ? *';

    @IsTest
    static void syncTest() {
        
        String jobId = System.schedule('FacturasScheduler',  CRON_EXP, new FacturasScheduler());

    }
}