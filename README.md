# Demo SMS Utilities

This package contains invocable Apex classes that send SMS messages to a mobile phone number from Salesforce. The utilities are meant to be a way to demo SMS messaging without the need to provision demo phone numbers or intgerate another telephony framework.

## `DemoCommunitySMSVerification`

This invocable Apex class sends a random *n*-digit numeric string to a mobile phone number and returns the string to the caller. It can be used as a simple form of verification in demos, and a sample [login flow](https://help.salesforce.com/articleView?id=security_login_flow_associate.htm&type=5) is included that uses the class to send a verification code to a user after he or she logs in.

## `DemoSendSMSMessage`

This invocable Apex class sends a text message to a mobile phone number and returns the string `SUCCESS` on successful sending of the SMS message or `FAILURE` along with an error message if for some reason the SMS cannot be sent.

## How It Works

The framework sends the SMS by sending an email to the mobile phone provider's text email address.  For example, a text to 123-555-1212 on the U.S. AT&T network will go to `1235551212@txt.att.net`. It is for this reason that it is imperative to know the cellular network of the demo persona's mobile phone during the demo.  For this reason, I have included a global value set that contains all of the acceptable mobile provider names and have placed a custom field on the `User` object as an example.

From here, it is a simple matter to retrieve the demo persona's mobile phone number (from the `User` or `Contact` record, for example) and the mobile network name (also from the same record, say) and pass those parameters to the desired Apex class from a flow or process.

## Security

I have also included a permission set called `Demo SMS Utilities` to grant access to the Apex classes in this package for demo personas without System Administrator profiles.

## How to Deploy This Package to Your Org

I am a pre-sales Solutions Engineer for [Salesforce](https://www.salesforce.com) and I develop solutions for my customers to demonstrate the capabilities of the amazing Salesforce platform. *This package represents functionality that I have used for demonstration purposes  and the content herein is definitely not ready for actual production use; specifically, it has not been tested extensively nor has it been written with security and access controls in mind. By installing this package, you assume all risk for any consequences and agree not to hold me or my company liable.*  If you are OK with that ...

Simply click the button below and log into your org:

<a href="https://githubsfdeploy.herokuapp.com">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png">
</a>