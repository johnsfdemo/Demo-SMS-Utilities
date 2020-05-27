//  Invocable Apex method that sends an SMS text message to a phone number.
//  Returns "SUCCESS" or "FAILURE" as an exit status and in the case of failure, an error message.
//  
//  This code is provided AS IS, with no warranty or guarantee of suitability for use.
//  Contact: john.meyer@salesforce.com

global without sharing class DemoSendSMSMessage {
    
    global class DemoPhoneSpec {
        @InvocableVariable (label='Mobile Phone Number' required=true)		global String phoneNumber;
        @InvocableVariable (label='Mobile Phone Provider' required=true)    global String mobileProvider;
        @InvocableVariable (label='Message' required=true) 					global String message;
    }
    
    global class Result {
        @InvocableVariable (label='Status')			global String status;
        @InvocableVariable (label='Error Message')	global String errorMessage;
    }
    
    private static final Map<String,String> mobileProviderMap = new Map<String,String> {
        'AT&T' => 'txt.att.net',
        'T-Mobile' => 'tmomail.net',
        'Verizon' => 'vtext.com',
        'Sprint' => 'messaging.sprintpcs.com',
        'Xfinity Mobile' => 'vtext.com',
        'Virgin Mobile'	=> 'vmobl.com',
        'Tracfone' => 'mmst5.tracfone.com',
        'Simple Mobile' => 'smtext.com',
        'Mint Mobile' => 'mailmymobile.net',
        'Red Pocket' => 'vtext.com',
        'Metro PCS' => 'mymetropcs.com',
        'Boost Mobile' => 'sms.myboostmobile.com',
        'Cricket' => 'sms.cricketwireless.net',
        'Republic Wireless' => 'text.republicwireless.com',
        'Google Fi' => 'msg.fi.google.com',
        'U.S. Cellular' => 'email.uscc.net',
        'Ting' => 'message.ting.com',
        'Consumer Cellular' => 'mailmymobile.net',
        'C-Spire' => 'cspire1.com',
        'Page Plus' => 'vtext.com'
    };
                
    @InvocableMethod (label='Send SMS Message' description='Sends an SMS message to the given phone number.')
    global static List<Result> sendSMSMessage (List<DemoPhoneSpec> phoneSpec) {
                    
    	Result returnStatus = new Result();
                    
    	if (!mobileProviderMap.containsKey(phoneSpec[0].mobileProvider) || String.isBlank(phoneSpec[0].phoneNumber)) {
        	returnStatus.status = 'FAILURE';
        	returnStatus.errorMessage = 'Bad mobile provider: ' + phoneSpec[0].mobileProvider;
        } else
        	try {           
    			Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
    			message.senderDisplayName = ConnectApi.Organization.getSettings().name;
    			message.toAddresses = new List<String> { phoneSpec[0].phoneNumber.replaceAll('[^0-9]','') + '@' + mobileProviderMap.get(phoneSpec[0].mobileProvider) };
    			message.plainTextBody = phoneSpec[0].message;
    			Messaging.sendEmail(new List<Messaging.SingleEmailMessage> { message });
                returnStatus.status = 'SUCCESS';
                returnStatus.errorMessage = null;
            } catch (Exception e) {
                returnStatus.status = 'FAILURE';
                returnStatus.errorMessage = 'Could not send SMS text message to ' + phoneSpec[0].phoneNumber.replaceAll('[^0-9]','') + ': ' + e.getMessage();
                System.debug(returnStatus.errorMessage);
            }
                    
    	return new List<Result> { returnStatus };
    }
}