String cronExp = '0 0 0/4 * * ?'; // har 4 ghante me chalega
System.schedule(
    'Forecast Dispatch Sync Job',
    cronExp,
    new ForecastDispatchScheduler()
);
