@isTest
public class AccountOverdueSyncTest {

    @isTest
    static void testUpdateAccounts() {

        Account acc = new Account(
            Name = 'Test Account',
            Customer_Code__c = 'C01126'
        );
        insert acc;

        Test.setMock(HttpCalloutMock.class, new MockGoogleResponse());

        Test.startTest();
            AccountOverdueSync.updateAccountsFromSheet();
        Test.stopTest();

        Account updatedAcc = [
            SELECT Overdue__c, Total_Outstanding_Amount__c
            FROM Account
            WHERE Id = :acc.Id
        ];

        System.assert(updatedAcc.Overdue__c != null);
        System.assert(updatedAcc.Total_Outstanding_Amount__c != null);
    }
}
