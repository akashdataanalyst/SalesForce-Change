/**
 * Scheduler for Account Overdue Sync (Every 4 Hours)
 * # Made by Akash
 */
global class AccountOverdueScheduler implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        AccountOverdueSync.updateAccountsFromSheet();
    }
}
