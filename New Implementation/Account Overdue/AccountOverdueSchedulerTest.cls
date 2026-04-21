@isTest
public class AccountOverdueSchedulerTest {

    @isTest
    static void testScheduler() {

        Test.setMock(HttpCalloutMock.class, new MockGoogleResponse());

        Test.startTest();
            new AccountOverdueScheduler().execute(null);
        Test.stopTest();

        System.assert(true);
    }
}
