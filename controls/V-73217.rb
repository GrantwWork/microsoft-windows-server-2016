control 'V-73217' do
  title "Users with Administrative privileges must have separate accounts for
  administrative duties and normal operational tasks."
  desc "Using a privileged account to perform routine functions makes the
  computer vulnerable to malicious software inadvertently introduced during a
  session that has been granted full privileges."
  impact 0.7
  tag "gtitle": 'SRG-OS-000480-GPOS-00227'
  tag "gid": 'V-73217'
  tag "rid": 'SV-87869r1_rule'
  tag "stig_id": 'WN16-00-000010'
  tag "fix_id": 'F-79663r1_fix'
  tag "cci": ['CCI-000366']
  tag "nist": ['CM-6 b', 'Rev_4']
  tag "documentable": false
  desc "check", "Verify each user with administrative privileges has been
  assigned a unique administrative account separate from their standard user
  account.
  If users with administrative privileges do not have separate accounts for
  administrative functions and standard user functions, this is a finding."
  desc "fix", "Ensure each user with administrative privileges has a separate account for user duties and one for privileged duties."

  describe "A manual review is required to verify that each user with administrative privileges has a separate account for user duties and one for privileged duties." do
    skip "A manual review is required to verify that each user with administrative privileges has a separate account for user duties and one for privileged duties."
  end
end
