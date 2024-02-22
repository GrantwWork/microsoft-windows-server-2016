control 'V-73747' do
  title "The Create a token object user right must not be assigned to any
  groups or accounts."
  desc "Inappropriate granting of user rights can provide system,
  administrative, and other high-level capabilities.

  The Create a token object user right allows a process to create an
  access token. This could be used to provide elevated rights and compromise a
  system.
  "
  impact 0.7
  tag "gtitle": 'SRG-OS-000324-GPOS-00125'
  tag "gid": 'V-73747'
  tag "rid": 'SV-88411r1_rule'
  tag "stig_id": 'WN16-UR-000090'
  tag "fix_id": 'F-80197r1_fix'
  tag "cci": ['CCI-002235']
  tag "nist": ['AC-6 (10)', 'Rev_4']
  tag "documentable": false
  desc "check", "Verify the effective setting in Local Group Policy Editor.

  Run gpedit.msc.

  Navigate to Local Computer Policy >> Computer Configuration >> Windows Settings
  >> Security Settings >> Local Policies >> User Rights Assignment.

  If any accounts or groups are granted the Create a token object user right,
  this is a finding.

  If an application requires this user right, this would not be a finding.

  Vendor documentation must support the requirement for having the user right.

  The requirement must be documented with the ISSO.

  The application account must meet requirements for application account
  passwords, such as length (WN16-00-000060) and required frequency of changes
  (WN16-00-000070).

  Passwords for application accounts with this user right must be protected as
  highly privileged accounts."
  desc "fix", "Configure the policy value for Computer Configuration >> Windows
  Settings >> Security Settings >> Local Policies >> User Rights Assignment >>
  Create a token object to be defined but containing no entries (blank)."
  describe security_policy do
    its('SeCreateTokenPrivilege') { should eq [] }
  end
end
