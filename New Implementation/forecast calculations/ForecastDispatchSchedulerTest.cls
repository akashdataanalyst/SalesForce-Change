@isTest
public class ForecastDispatchSchedulerTest {

    @isTest
    static void testSchedulerExecution() {

        // 🔹 Basic data (minimum required)
        Opportunity opp = new Opportunity(
            Name = 'Test Opp',
            StageName = 'Prospecting',
            CloseDate = Date.today()
        );
        insert opp;

        Sales_Order__c so = new Sales_Order__c(
            Opportunity__c = opp.Id
        );
        insert so;

        Forecast__c fc = new Forecast__c(
            Opportunity__c = opp.Id
        );
        insert fc;

        Dispatch__c d = new Dispatch__c(
            Sales_Order__c = so.Id
        );
        insert d;

        Test.startTest();

            // 🔥 Schedule the job
            String cronExp = '0 0 0/4 * * ?';
            System.schedule('Test Forecast Scheduler', cronExp, new ForecastDispatchScheduler());

        Test.stopTest();

        // 🔹 Verify job created
        CronTrigger ct = [
            SELECT Id, CronExpression, State
            FROM CronTrigger
            WHERE CronJobDetail.Name = 'Test Forecast Scheduler'
            LIMIT 1
        ];

        System.assertEquals('WAITING', ct.State);
    }
}
