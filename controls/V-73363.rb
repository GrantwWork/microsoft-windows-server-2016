control 'V-73363' do
  title 'The Kerberos user ticket lifetime must be limited to 10 hours or less.'
  desc  "In Kerberos, there are two types of tickets: Ticket Granting Tickets
  (TGTs) and Service Tickets. Kerberos tickets have a limited lifetime so the
  time an attacker has to implement an attack is limited. This policy controls
  how long TGTs can be renewed. With Kerberos, the user's initial authentication
  to the domain controller results in a TGT, which is then used to request
  Service Tickets to resources. Upon startup, each computer gets a TGT before
  requesting a service ticket to the domain controller and any other computers it
  needs to access. For services that start up under a specified user account,
  users must always get a TGT first and then get Service Tickets to all computers
  and services accessed.
  "
  impact 0.5
  tag "gtitle": 'SRG-OS-000112-GPOS-00057'
  tag "satisfies": ['SRG-OS-000112-GPOS-00057', 'SRG-OS-000113-GPOS-00058']
  tag "gid": 'V-73363'
  tag "rid": 'SV-88015r1_rule'
  tag "stig_id": 'WN16-DC-000040'
  tag "fix_id": 'F-79805r1_fix'
  tag "cci": ['CCI-001941', 'CCI-001942']
  tag "nist": ['IA-2 (8)', 'IA-2 (9)', 'Rev_4']
  tag "documentable": false
  desc "check", "This applies to domain controllers. It is NA for other systems.

  Verify the following is configured in the Default Domain Policy.

  Open Group Policy Management.

  Navigate to Group Policy Objects in the Domain being reviewed (Forest >>
  Domains >> Domain).

  Right-click on the Default Domain Policy.

  Select Edit.

  Navigate to Computer Configuration >> Policies >> Windows Settings >> Security
  Settings >> Account Policies >> Kerberos Policy.

  If the value for Maximum lifetime for user ticket is 0 or greater than
  10 hours, this is a finding."
  desc "fix", "Configure the policy value in the Default Domain Policy for
  Computer Configuration >> Policies >> Windows Settings >> Security Settings >>
  Account Policies >> Kerberos Policy >> Maximum lifetime for user ticket to
  a maximum of 10 hours but not 0, which equates to Ticket doesn't
  expire."
  domain_role = command('wmic computersystem get domainrole | Findstr /v DomainRole').stdout.strip

  if domain_role == '4' || domain_role == '5'
    describe.one do
      describe security_policy do
        its('MaxTicketAge') { should be > 0 }
      end
      describe security_policy do
        its('MaxTicketAge') { should be <= 10 }
      end
    end
  end

  if domain_role != '4' && domain_role != '5'
    impact 0.0
    describe 'This system is not a domain controller, therefore this control is not applicable as it only applies to domain controllers' do
      skip 'This system is not a domain controller, therefore this control is not applicable as it only applies to domain controllers'
    end
  end
end
