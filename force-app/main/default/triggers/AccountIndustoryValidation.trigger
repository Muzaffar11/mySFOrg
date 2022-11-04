trigger AccountIndustoryValidation on Account (before insert) {

    for(Account acc : Trigger.new){
        if(acc.Industry == 'Education')
        {
            acc.addError('Education.org not allow ');
        }
    }
    
}