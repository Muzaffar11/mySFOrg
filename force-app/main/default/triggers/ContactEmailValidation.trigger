trigger ContactEmailValidation on Contact (before insert,before update) {

    for(contact con : trigger.new){
        if (trigger.isinsert && con.Email == NULL){
            con.adderror('Email not empty');
        }
        if (Trigger.isupdate && con.Email == NULL){
            con.adderror('Email not empty 2');
        }
    }
}