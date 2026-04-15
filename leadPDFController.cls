public class leadPDFController {
    public lead__c leads { get; set; }
    public String ownerName {get; set;}
    public boolean isYesRegulatory {get; set;}
    public boolean isNoRegulatory {get; set;}
    public boolean isYesCriticalMajor {get; set;}
    public boolean isNoCriticalMajor {get; set;}
    public boolean isYesCriticalMinor {get; set;}
    public boolean isNoAethics {get; set;}
    public boolean isYesAethics {get; set;}
    public boolean isNoFlammability {get; set;}
    public boolean isYesFlammability {get; set;}
    public boolean isNoCriticalMinor {get; set;}
    public boolean isNoFric {get; set;}
    public boolean isYesFric {get; set;}
    public boolean isNoWelding {get; set;}
    public boolean isYesWelding {get; set;}
    public boolean isNoPadPrinting {get; set;}
    public boolean isYesPadPrinting {get; set;}
    public boolean isNoLaserMarking {get; set;}
    public boolean isYesLaserMarking {get; set;}
    public boolean isNoSampleCollected {get; set;}
    public boolean isYesSampleCollected {get; set;}
    public boolean isNoExpectedAnnual {get; set;}
    public boolean isYesExpectedAnnual {get; set;}
    public boolean isNoBlankSpot {get; set;}
    public boolean isYesBlankSpot {get; set;}
    public boolean isNoMetal_Contaminated {get; set;}
    public boolean isYesMetal_Contaminated {get; set;}
    public boolean isNoColor {get; set;}
    public boolean isYesColor {get; set;}
    public boolean isNoSampleQuantityNeeded {get; set;}
    public boolean isYesSampleQuantityNeeded {get; set;}
    public boolean isNoSampleCollectionWeight {get; set;}
    public boolean isYesSampleCollectionWeight {get; set;}
    public boolean isNoSampleRetention {get; set;}
    public boolean isYesSampleRetention {get; set;}
    
    
    
    public string ownerEmail {get;set;}
    public Integer currentYear {get;set;}
    public string TxtAutoNumber{get;set;}
        
    public Integer AutoNumCSR {get;set;}
    
    public LeadPDFController(ApexPages.StandardController stdController){
        this.leads=(lead__c) stdController.getRecord();
        fetchOppLead();
    }
    
    public void fetchOppLead(){
        //lead__c lead=new lead__c();
        leads=[SELECT NSLNumber__c,Contact_First_Name__c,Potential_Name__c,name,
               Designation__c,owner.name,owner.Email,Application_Area__c,Component_Name__c,Part_Weight_gms__c,
                                  Part_Thickness_Min_mm__c,Part_Thickness_Max_mm__c,Production_Description__c,
                                  Current_Supplier_Grade__c,Regulatory_Requirement__c,Major_Critical_Parameter__c,Minor_Critical_Parameter__c,
                                  Flammability_Requirement__c,Aethics__c, Laser_Marking__c,Pad_Printing_Requirement__c,
                                  Welding__c,Fric__c,Color__c,Metal_Contaminated__c,Black_Spot__c,Expected_Annual_Volume_Kgs__c,
                                  Sample_Collected__c,Sample_Collection_Weight__c,Sample_Quantity_Needed_Kgs__c,Sample_Retention__c FROM lead__c where Id=:leads.id];
    	ownerName=leads.owner.name;
        ownerEmail=leads.owner.Email;
        currentYear = Date.today().year();
        Custom_Opportunity__c CustomSettingRecord =[SELECT ID,CSRNumber__c FROM Custom_Opportunity__c LIMIT 1];
        AutoNumCSR =Integer.valueOf( CustomSettingRecord.CSRNumber__c);
        if(AutoNumCSR <10){
            TxtAutoNumber='000'+string.valueOf(AutoNumCSR);
        }else if(AutoNumCSR >=10 && AutoNumCSR <100){
            TxtAutoNumber='00'+string.valueOf(AutoNumCSR);
        }
        else if(AutoNumCSR >99 && AutoNumCSR <1000){
            TxtAutoNumber='0'+string.valueOf(AutoNumCSR);
        }else if(AutoNumCSR >=1000){
            TxtAutoNumber=string.valueOf(AutoNumCSR);
        }
        checkNull(leads);
        
    }
    public void checkNull(lead__c leads){
        isYesRegulatory = (leads.Regulatory_Requirement__c != null && leads.Regulatory_Requirement__c.trim() != 'No');
        isNoRegulatory =!isYesRegulatory;
        isYesCriticalMajor=(leads.Major_Critical_Parameter__c != null && leads.Major_Critical_Parameter__c.trim() != 'No');
        isNoCriticalMajor=!isYesCriticalMajor;
        isYesCriticalMinor=(leads.Minor_Critical_Parameter__c != null && leads.Minor_Critical_Parameter__c.trim() != 'No');
        isNoCriticalMinor=!isYesCriticalMinor;
        isYesFlammability=(leads.Flammability_Requirement__c != null && leads.Flammability_Requirement__c.trim() != 'No' );
        isNoFlammability=!isYesFlammability;
        isYesAethics=(leads.Aethics__c != null && leads.Aethics__c.trim() != 'No');
        isNoAethics=!isYesAethics;
        isYesLaserMarking=(leads.Laser_Marking__c != null && leads.Laser_Marking__c.trim() != 'No');
        isNoLaserMarking=!isYesLaserMarking;
        isYesPadPrinting=(leads.Pad_Printing_Requirement__c != null && leads.Pad_Printing_Requirement__c.trim() != 'No');
        isNoPadPrinting=!isYesPadPrinting;
        isYesWelding=(leads.Welding__c != null && leads.Welding__c.trim() != 'No');
        isNoWelding=!isYesWelding;
        isYesFric=(leads.Fric__c != null && leads.Fric__c.trim() != 'No');
        isNoFric=!isYesFric;
        isYesColor=(leads.Color__c != null && leads.Color__c.trim() != 'No');
        isNoColor=!isYesColor;
        isYesMetal_Contaminated=(leads.Metal_Contaminated__c != null && leads.Metal_Contaminated__c.trim() != 'No');
        isNoMetal_Contaminated=!isYesMetal_Contaminated;
        isYesBlankSpot=(leads.Black_Spot__c != null && leads.Black_Spot__c.trim() != '' && leads.Black_Spot__c.trim() !='No' && leads.Black_Spot__c.trim() !='NO' && leads.Black_Spot__c.trim() !='no');
        isNoBlankSpot=!isYesBlankSpot;
    	isYesExpectedAnnual=(leads.Expected_Annual_Volume_Kgs__c != null && leads.Expected_Annual_Volume_Kgs__c !=0);
        isNoExpectedAnnual=!isYesExpectedAnnual;
        isYesSampleCollected=(leads.Sample_Collected__c != null && leads.Sample_Collected__c != 'No');
        isNoSampleCollected=!isYesSampleCollected;
        isYesSampleCollectionWeight=(leads.Sample_Collection_Weight__c != null && leads.Sample_Collection_Weight__c != 0);
        isNoSampleCollectionWeight=!isYesSampleCollectionWeight;
    	isYesSampleQuantityNeeded=(leads.Sample_Quantity_Needed_Kgs__c != null && leads.Sample_Quantity_Needed_Kgs__c != 0);
        isNoSampleQuantityNeeded=!isYesSampleQuantityNeeded;

        isYesMetal_Contaminated=(leads.Metal_Contaminated__c != null && leads.Metal_Contaminated__c.trim() != 'No');
        isNoMetal_Contaminated=!isYesMetal_Contaminated;
        isYesSampleRetention=(leads.Sample_Retention__c != null && leads.Sample_Retention__c.trim() != 'No');
        isNoSampleRetention=!isYesSampleRetention;
    
    }
    
    
		
    

}
