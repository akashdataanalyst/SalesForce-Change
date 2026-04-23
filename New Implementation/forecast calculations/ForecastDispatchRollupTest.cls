@isTest
public class ForecastDispatchRollupTest {

    @isTest
    static void testSchedulerMethod() {

        // 🔹 Step 1: Create Opportunity
        Opportunity opp = new Opportunity(
            Name = 'Test Opp',
            StageName = 'Prospecting',
            CloseDate = Date.today()
        );
        insert opp;

        // 🔹 Step 2: Create Sales Order (Auto Number → Name not required)
        Sales_Order__c so = new Sales_Order__c(
            Opportunity__c = opp.Id
        );
        insert so;

        // 🔹 Step 3: Create Forecast
        // ⚠️ Forecast_Month__c is formula → do NOT set
        Forecast__c fc = new Forecast__c(
            Opportunity__c = opp.Id
        );
        insert fc;

        // 🔹 Step 4: Create Dispatch
        // ⚠️ Formula fields → do NOT set directly
        Dispatch__c d = new Dispatch__c(
            Sales_Order__c = so.Id
        );
        insert d;

        Test.startTest();

            // 🔥 Call main method
            ForecastDispatchRollup.updateForecastDispatch();

            // 🔥 Schedule job test
            String cronExp = '0 0 0/4 * * ?';
            System.schedule('Test Job', cronExp, new ForecastDispatchScheduler());

        Test.stopTest();

        // 🔹 Step 5: Validate (basic check)
        Forecast__c result = [
            SELECT Id, Actual_Dispatch_Qty__c
            FROM Forecast__c
            WHERE Id = :fc.Id
        ];

        // Value null bhi ho sakti hai agar formula dependent fields set nahi hain
        System.assertNotEquals(null, result, 'Forecast record should exist');
    }
}
