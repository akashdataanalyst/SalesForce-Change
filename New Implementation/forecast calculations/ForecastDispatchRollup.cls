public class ForecastDispatchRollup {

    public static void updateForecastDispatch() {

        // Step 1: Get Dispatch records
        List<Dispatch__c> dispatchList = [
            SELECT 
                Sales_Order__r.Opportunity__c,
                Dispatch_Month__c,
                FG_Quantity_Number__c
            FROM Dispatch__c
            WHERE Sales_Order__r.Opportunity__c != null
            AND Dispatch_Month__c != null
        ];

        // Step 2: Aggregate (Opportunity + Month)
        Map<String, Decimal> dispatchMap = new Map<String, Decimal>();

        for (Dispatch__c d : dispatchList) {

            // Extra safety (relationship null check)
            if (d.Sales_Order__r == null || d.Sales_Order__r.Opportunity__c == null) {
                continue;
            }

            // Null-safe quantity
            Decimal qty = d.FG_Quantity_Number__c != null ? d.FG_Quantity_Number__c : 0;

            String key = d.Sales_Order__r.Opportunity__c + '-' + d.Dispatch_Month__c;

            if (dispatchMap.containsKey(key)) {
                dispatchMap.put(key, dispatchMap.get(key) + qty);
            } else {
                dispatchMap.put(key, qty);
            }
        }

        // Step 3: Get Forecast records
        List<Forecast__c> forecasts = [
            SELECT Id, Opportunity__c, Forecast_Month__c, Actual_Dispatch_Qty__c
            FROM Forecast__c
            WHERE Opportunity__c != null
            AND Forecast_Month__c != null
        ];

        List<Forecast__c> updates = new List<Forecast__c>();

        // Step 4: Match & update
        for (Forecast__c f : forecasts) {

            String key = f.Opportunity__c + '-' + f.Forecast_Month__c;

            if (dispatchMap.containsKey(key)) {
                f.Actual_Dispatch_Qty__c = dispatchMap.get(key);
            } else {
                f.Actual_Dispatch_Qty__c = 0;
            }

            updates.add(f);
        }

        // Step 5: Update Forecast
        if (!updates.isEmpty()) {
            update updates;
        }
    }
}
