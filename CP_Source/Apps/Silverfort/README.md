# Silverfort Client (21 July) (Debug Testing with client)

|  CP Information |            |
|-----------------|------------|
| Package | Silverfort Client - Current Stable Version |
| Script Name | [silverfort-cp-init-script.sh](build/silverfort-cp-init-script.sh) |
| CP Mount Path | /custom/silverfort |
| CP Size | 400M |
| IGEL OS Version (min) | 11.05.133 |
| Packaging Notes | See build script for details. |
| Package automation | [build-silverfort-cp.sh](build/build-silverfort-cp.sh) |

----

## Packaging notes (Version: 2.5.6-297)

- Configured the Desktop App to start automatically

### Steps to be done on each client

- Download the certificate and the root CA certificate in DER/Base64 format (.cer extension).

- Add the messaging service certicate to the NSS DB:

```
certutil -d sql:$HOME/.pki/nssdb -A -t "C,," -n <cert-display- name> -i <cert path>
  ```

- Add a root CA certicate to the NSS DB:  

```
certutil -d sql:$HOME/.pki/nssdb -A -t "C,," -n <cert-display- name> -i <cert path>
  ```

- Restart IGEL OS  

### Configure the Desktop Application

These configurations are optional.

- Open the Silverfort Desktop App (icon on Menu Bar)

- Enter your corporate email address

- Click Send Verification (Silverfort checks the email address with your organization's Silverfort MFA servers and, if you have been configured for MFA, you will receive an email containing a verification code)

- Type the verification code into the Silverfort Client, then click Verify Account (Upon successful verification, a confirmation message appears)
