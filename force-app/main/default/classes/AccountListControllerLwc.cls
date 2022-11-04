public with sharing class AccountListControllerLwc {

   @AuraEnabled(cacheable=true)
    public static List<Account> queryAccountsByRevenue(Decimal annualRevenue) {
      return [
          SELECT  ID,Name, AnnualRevenue
          FROM Account
          WHERE AnnualRevenue >= :annualRevenue
          WITH SECURITY_ENFORCED
     ];
  }
  
}