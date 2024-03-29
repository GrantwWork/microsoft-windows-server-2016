control 'V-73361' do
  title "The Kerberos service ticket maximum lifetime must be limited to 600
  minutes or less."
  desc "This setting determines the maximum amount of time (in minutes) that a
  granted session ticket can be used to access a particular service. Session
  tickets are used only to authenticate new connections with servers. Ongoing
  operations are not interrupted if the session ticket used to authenticate the
  connection expires during the connection.
  "
  impact 0.5
  tag "gtitle": 'SRG-OS-000112-GPOS-00057'
  tag "satisfies": ['SRG-OS-000112-GPOS-00057', 'SRG-OS-000113-GPOS-00058']
  tag "gid": 'V-73361'
  tag "rid": 'SV-88013r1_rule'
  tag "stig_id": 'WN16-DC-000030'
  tag "fix_id": 'F-79803r1_fix'
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

  If the value for Maximum lifetime for service ticket is 0 or greater
  than 600 minutes, this is a finding."
  desc "fix", "Configure the policy value in the Default Domain Policy for
  Computer Configuration >> Policies >> Windows Settings >> Security Settings >>
  Account Policies >> Kerberos Policy >> Maximum lifetime for service ticket
  to a maximum of 600 minutes, but not 0, which equates to Ticket
  doesn't expire."
  domain_role = command('wmic computersystem get domainrole | Findstr /v DomainRole').stdout.strip

  if domain_role == '4' || domain_role == '5'
    describe security_policy do
      its('MaxServiceAge') { should be > 0 }
    end
    describe security_policy do
      its('MaxServiceAge') { should be <= 600 }
    end
  end

  if domain_role != '4' && domain_role != '5'
    impact 0.0
    describe 'This system is not a domain controller, therefore this control is not applicable as it only applies to domain controllers' do
      skip 'This system is not a domain controller, therefore this control is not applicable as it only applies to domain controllers'
    end
  end
end
