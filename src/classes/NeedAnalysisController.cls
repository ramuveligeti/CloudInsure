public with sharing class NeedAnalysisController {
	public Need_Analysis__c na{get;set;}
	public Need_Analysis__c needAnalysis{get;set;}
	public List<dependentWrapper> dependents{get;set;}
	public NeedAnalysisController(ApexPages.StandardController stdCont) {
		na = (Need_Analysis__c)stdCont.getRecord();
		dependents = new List<dependentWrapper>();
	}

	public NeedAnalysisController(){
		needAnalysis = new Need_Analysis__c();
	}

	public void addNewDependent(){
		dependents.add(new dependentWrapper(new Dependent__c()));
	}

	public void deleteRows(){
		List<dependentWrapper> dependentsNew = new List<dependentWrapper>();
		for(dependentWrapper dw: dependents){
			if(!dw.selected){
				dependentsNew.add(dw);
			}
		}
		dependents.clear();
		dependents.addAll(dependentsNew);
	}

	@RemoteAction
	public static ID updatePersonalDetails(String na){
		system.debug('na=='+na);
		JSONParser parser = JSON.createParser(na);
		Need_Analysis__c wrap = (Need_Analysis__c)parser.readValueAs(Need_Analysis__c.class);
		upsert wrap;
		return wrap.Id;
	}

	@RemoteAction
	public static List<Dependent__c> createDependents(String naId, String dp){
		/*List<Dependent__c> dps = [Select ID from Dependent__c where Need_Analysis__c = :naId];
		if(!dps.isEmpty()){
			delete dps;
		}
		*/
		system.debug('dp=='+dp);
		JSONParser parser = JSON.createParser(dp);
		List<Dependent__c> wrap = (List<Dependent__c>)JSON.deserialize(dp,List<Dependent__c>.class);
		upsert wrap;
		return wrap;
	}

	@RemoteAction
	public static void deleteDependents(List<String> dpId){
		List<Dependent__c> dpList = new List<Dependent__c>();
		for(String dp: dpId){
			dpList.add(new Dependent__c(Id = dp));
		}
		if(!dpList.isEmpty()){delete dpList;}
	}

	public class dependentWrapper{
		public Boolean selected{get;set;}
		public Dependent__c dependent{get;set;}

		public dependentWrapper(Dependent__c d){
			selected = false;
			dependent = d;
		}
	}
}