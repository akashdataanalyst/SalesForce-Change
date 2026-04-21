@isTest
global class MockGoogleResponse implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');

        String body = JSON.serialize(new Map<String, Object>{
            'values' => new List<Object>{

                // Header
                new List<Object>{
                    'Date','Ref','Party Name','Opening','Pending','Due','Overdue Days'
                },

                // Overdue (>=0)
                new List<Object>{
                    '13-Jan-26','Ref1','Absan Polymers (C01126)','0','100000 Dr','14-Mar-26','10'
                },

                // Not Due (<0)
                new List<Object>{
                    '14-Jan-26','Ref2','Absan Polymers (C01126)','0','50000 Dr','15-Mar-26','-5'
                }
            }
        });

        res.setBody(body);
        res.setStatusCode(200);

        return res;
    }
}
