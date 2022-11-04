trigger OpportunityClassTrigger on Opportunity (before insert) {
  OpportunityTriggerClass.check_opp(Trigger.New);
}