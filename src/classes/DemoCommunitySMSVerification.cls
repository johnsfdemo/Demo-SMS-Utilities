//  Invocable Apex method that generates and sends an n-digit verification code in a text message and returns the code to the caller
//  for verification in flows.
//  
//  This code is provided AS IS, with no warranty or guarantee of suitability for use.
//  Contact: john.meyer@salesforce.com

global without sharing class DemoCommunitySMSVerification {

    global class DemoSMSVerificationPhoneSpec {
        @InvocableVariable (label='Mobile Phone Number' required=true)           global String phoneNumber;
        @InvocableVariable (label='Mobile Phone Provider' required=true)         global String mobileProvider;
        @InvocableVariable (label='Number of Verification Digits' required=true) global Integer numberOfDigits;
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
    
    @InvocableMethod (label='Generate and Send Verification Code' description='Generates and sends a verification code to the given phone number.')
    global static List<String> generateAndSendCode (List<DemoSMSVerificationPhoneSpec> phoneSpec) {

		if (!mobileProviderMap.containsKey(phoneSpec[0].mobileProvider) || String.isBlank(phoneSpec[0].phoneNumber))
            return null;

        String validationCode = String.valueOf((Integer) Math.floor(Math.random() * Math.pow((Double) 10, (Double) phoneSpec[0].numberOfDigits))).leftPad(phoneSpec[0].numberOfDigits, '0');
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.senderDisplayName = ConnectApi.Organization.getSettings().name;
        message.toAddresses = new List<String> { phoneSpec[0].phoneNumber.replaceAll('[^0-9]','') + '@' + mobileProviderMap.get(phoneSpec[0].mobileProvider) };
        message.plainTextBody = 'Your verification code is: ' + validationCode;
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage> { message });
        
        return new List<String> { validationCode };
    }
}