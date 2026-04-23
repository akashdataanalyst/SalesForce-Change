global class ForecastDispatchScheduler implements Schedulable {

    global void execute(SchedulableContext sc) {
        ForecastDispatchRollup.updateForecastDispatch();
    }
}
