# SalesForce-Change

sandbox se Outbond change set 


in production  Setup Deployment Settings 
All sandbox here and edit our sandbox 
And Check Box tick 
Allow Inbound Changes	 


Production pr inbond change set 
Run Specified Tests ke saath ek test class bhee add karni hogi ismey 




📘 Salesforce ↔ Google Sheet Integration Notes
(Account Overdue Sync | # Made by Akash)

🔷 1. Google Cloud Setup (GCP)
✅ Project & API
Google Cloud पर project बनाया
Google Sheets API enable किया
✅ OAuth Client

Path:

APIs & Services → Credentials
OAuth Client ID बनाया
Type: Web App
🔹 Redirect URI (Important)
https://momentum-data-4273--akash.sandbox.my.salesforce.com/services/authcallback/GoogleSheet_Integration

(Production optional)

https://login.salesforce.com/services/authcallback/GoogleSheet_Integration
🔷 2. Salesforce Auth Setup
✅ Auth Provider (Google)
Name: GoogleSheet Integration
URL Suffix: GoogleSheet_Integration
Scope:
https://www.googleapis.com/auth/spreadsheets
🔷 3. External Credential Setup
✅ External Credential
Name: GoogleSheet External
Authentication Protocol: OAuth 2.0
🔹 Principal
Type: Named Principal
🔹 Permission Set Mapping
External Credential को Permission Set से map किया
User को वो permission set assign किया
🔷 4. Named Credential Setup (IMPORTANT)
✅ Named Credential
Name: Googlesheet
URL:
https://sheets.googleapis.com
External Credential: GoogleSheet External
Identity Type: Named Principal
🔹 Authentication Step

👉 Named Credential खोलकर:

Click: Authenticate
Google login किया
Access allow किया

✔️ Token generate हो गया

🔷 5. Google Sheet Structure

Tab Name: Account

AccountId	Overdue__c
001xxxxx	12000
🔷 6. Apex Callout Class
/**
 * Account Overdue Sync from Google Sheet
 * # Made by Akash
 */
public class AccountOverdueSync {

    public static void updateAccountsFromSheet() {

        Http http = new Http();
        HttpRequest req = new HttpRequest();

        req.setEndpoint('callout:Googlesheet/v4/spreadsheets/1u-EL2aqTukR8suSKKX7nHe5k1LoLiW9eFyH0mZK1IxE/values/Account');
        req.setMethod('GET');

        HttpResponse res = http.send(req);

        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        List<Object> values = (List<Object>) result.get('values');

        List<Account> accList = new List<Account>();

        for(Integer i = 1; i < values.size(); i++) {

            List<Object> row = (List<Object>) values[i];

            if(row.size() < 2) continue;

            String accId = String.valueOf(row[0]).trim();
            String overdueStr = String.valueOf(row[1]).trim();

            if(String.isBlank(accId)) continue;

            Decimal overdue = 0;
            if(!String.isBlank(overdueStr)) {
                overdue = Decimal.valueOf(overdueStr);
            }

            accList.add(new Account(
                Id = accId,
                Overdue__c = overdue
            ));
        }

        if(!accList.isEmpty()) {
            update accList;
        }
    }
}
🔷 7. Scheduler Class
/**
 * Scheduler for Account Overdue Sync (Every 4 Hours)
 * # Made by Akash
 */
global class AccountOverdueScheduler implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        AccountOverdueSync.updateAccountsFromSheet();
    }
}
🔷 8. Schedule Job
System.schedule(
    'Account Overdue Sync (4 Hourly)',
    '0 0 0/4 * * ?',
    new AccountOverdueScheduler()
);
🔷 9. Manual Run (Testing)
AccountOverdueSync.updateAccountsFromSheet();
🔷 10. Monitoring
🔹 Scheduled Jobs
Setup → Scheduled Jobs
🔹 Apex Jobs
Setup → Apex Jobs
🔷 11. Common Errors
❌ redirect_uri_mismatch

✔ Fix: सही callback URL Google Cloud में add करो

❌ external credential not configured

✔ Fix: Named Credential → Authenticate

❌ job already scheduled

✔ Fix: पुराने jobs delete करो

🔷 12. Final Flow
Google Sheet → Google API → Named Credential → Apex Callout → Account Update → Scheduler (4 Hourly)
🚀 Final Status

✔ Google Cloud setup
✔ Auth Provider working
✔ External Credential working
✔ Named Credential working
✔ Apex integration working
✔ Scheduler running


