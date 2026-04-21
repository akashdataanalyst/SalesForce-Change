/**
 * Account Overdue + Outstanding Sync from Google Sheet
 * # Made by Akash
 */
public class AccountOverdueSync {

    public static void updateAccountsFromSheet() {

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Googlesheet/v4/spreadsheets/1JSwUZTosKz3jFIZP471qS2-eAZZ-3EtdCAZJS2KEfNA/values/AR');
        req.setMethod('GET');

        HttpResponse res = new Http().send(req);

        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        List<Object> values = (List<Object>) result.get('values');

        // Aggregation maps
        Map<String, Decimal> overdueMap = new Map<String, Decimal>();
        Map<String, Decimal> outstandingMap = new Map<String, Decimal>();

        for (Integer i = 1; i < values.size(); i++) {

            List<Object> row = (List<Object>) values[i];

            // Safety check
            if (row.size() < 7) continue;

            // 🔹 1. Party Name → Extract Customer Code
            String partyName = String.valueOf(row[2]);
            if (String.isBlank(partyName) || !partyName.contains('(')) continue;

            String customerCode = partyName.substring(
                partyName.indexOf('(') + 1,
                partyName.indexOf(')')
            ).trim();

            // 🔹 2. Pending Amount (E column)
            String pendingStr = String.valueOf(row[4]);

            if (String.isBlank(pendingStr)) continue;

            pendingStr = pendingStr.replace('Dr', '').replace(',', '').trim();

            Decimal pendingAmt;
            try {
                pendingAmt = Decimal.valueOf(pendingStr);
            } catch (Exception e) {
                continue; // skip bad data
            }

            // 🔹 3. Overdue Days (G column)
            String daysStr = String.valueOf(row[6]).trim();

            Integer days = 0;
            try {
                if (!String.isBlank(daysStr)) {
                    days = Integer.valueOf(daysStr);
                }
            } catch (Exception e) {
                continue;
            }

            // 🔥 4. Logic
            if (days >= 0) {
                overdueMap.put(
                    customerCode,
                    (overdueMap.containsKey(customerCode) ? overdueMap.get(customerCode) : 0) + pendingAmt
                );
            } else {
                outstandingMap.put(
                    customerCode,
                    (outstandingMap.containsKey(customerCode) ? outstandingMap.get(customerCode) : 0) + pendingAmt
                );
            }
        }

        // 🔹 5. Fetch Accounts
        Set<String> allCodes = new Set<String>();
        allCodes.addAll(overdueMap.keySet());
        allCodes.addAll(outstandingMap.keySet());

        if (allCodes.isEmpty()) return;

        List<Account> accList = [
            SELECT Id, Customer_Code__c
            FROM Account
            WHERE Customer_Code__c IN :allCodes
        ];

        // 🔹 6. Update Accounts
        List<Account> updateList = new List<Account>();

        for (Account acc : accList) {

            Decimal overdue = overdueMap.containsKey(acc.Customer_Code__c)
                ? overdueMap.get(acc.Customer_Code__c)
                : 0;

            Decimal outstanding = outstandingMap.containsKey(acc.Customer_Code__c)
                ? outstandingMap.get(acc.Customer_Code__c)
                : 0;

            acc.Overdue__c = overdue;
            acc.Total_Outstanding_Amount__c = outstanding;

            updateList.add(acc);
        }

        if (!updateList.isEmpty()) {
            update updateList;
        }
    }
}
