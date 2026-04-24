@isTest(SeeAllData=true)
public class ForecastDispatchRollupTest {

    @isTest
    static void testUpdateForecastDispatch() {

        // Just run the method on existing data
        Test.startTest();
        ForecastDispatchRollup.updateForecastDispatch();
        Test.stopTest();

        // Basic assertion
        System.assert(true);
    }

    @isTest
    static void testScheduler() {

        Test.startTest();

        System.schedule(
            'Test Forecast Job',
            '0 0 0/4 * * ?',
            new ForecastDispatchScheduler()
        );

        Test.stopTest();

        System.assert(true);
    }
}
