control 'V-73227' do
  title "Members of the Backup Operators group must have separate accounts for
  backup duties and normal operational tasks."
  desc "Backup Operators are able to read and write to any file in the system,
  regardless of the rights assigned to it. Backup and restore rights permit users
  to circumvent the file access restrictions present on NTFS disk drives for
  backup and restore purposes. Members of the Backup Operators group must have
  separate logon accounts for performing backup duties."
  impact 0.5
  tag "gtitle": 'SRG-OS-000480-GPOS-00227'
  tag "gid": 'V-73227'
  tag "rid": 'SV-87879r1_rule'
  tag "stig_id": 'WN16-00-000050'
  tag "fix_id": 'F-79671r1_fix'
  tag "cci": ['CCI-000366']
  tag "nist": ['CM-6 b', 'Rev_4']
  tag "documentable": false
  desc "check", "If no accounts are members of the Backup Operators group, this
  is NA.

  Verify users with accounts in the Backup Operators group have a separate user
  account for backup functions and for performing normal user tasks.

  If users with accounts in the Backup Operators group do not have separate
  accounts for backup functions and standard user functions, this is a finding."
  desc "fix", "Ensure each member of the Backup Operators group has separate
  accounts for backup functions and standard user functions."

  backup_operators = attribute('backup_operators')
  backup_operators_group = command("net localgroup 'Backup Operators' | Format-List | Findstr /V 'Alias Name Comment Members - command'").stdout.strip.split("\r\n")

  if !backup_operators_group.empty?
    backup_operators_group.each do |user|
      describe user do
        it { should be_in backup_operators }
      end
    end
  end
  if backup_operators_group.empty?
    impact 0.0
    describe 'There are no users in the Backup Operators Group, therefore this control is not applicable' do
      skip 'There are no users in the Backup Operators Group, therefore this control is not applicable'
    end
  end
end
