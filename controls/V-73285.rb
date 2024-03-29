control 'V-73285' do
  title "Windows Server 2016 must automatically remove or disable emergency
  accounts after the crisis is resolved or within 72 hours."
  desc "Emergency administrator accounts are privileged accounts established
  in response to crisis situations where the need for rapid account activation is
  required. Therefore, emergency account activation may bypass normal account
  authorization processes. If these accounts are automatically disabled, system
  maintenance during emergencies may not be possible, thus adversely affecting
  system availability.

  Emergency administrator accounts are different from infrequently used
  accounts (i.e., local logon accounts used by system administrators when network
  or normal logon/access is not available). Infrequently used accounts are not
  subject to automatic termination dates. Emergency accounts are accounts created
  in response to crisis situations, usually for use by maintenance personnel. The
  automatic expiration or disabling time period may be extended as needed until
  the crisis is resolved; however, it must not be extended indefinitely. A
  permanent account should be established for privileged users who need long-term
  maintenance accounts.

  To address access requirements, many operating systems can be integrated
  with enterprise-level authentication/access mechanisms that meet or exceed
  access control policy requirements.
  "
  impact 0.5
  tag "gtitle": 'SRG-OS-000123-GPOS-00064'
  tag "gid": 'V-73285'
  tag "rid": 'SV-87937r1_rule'
  tag "stig_id": 'WN16-00-000340'
  tag "fix_id": 'F-79729r1_fix'
  tag "cci": ['CCI-001682']
  tag "nist": ['AC-2 (2)', 'Rev_4']
  tag "documentable": false
  desc "check", "Determine if emergency administrator accounts are used and
  identify any that exist. If none exist, this is NA.

  If emergency administrator accounts cannot be configured with an expiration
  date due to an ongoing crisis, the accounts must be disabled or removed when
  the crisis is resolved.

  If emergency administrator accounts have not been configured with an expiration
  date or have not been disabled or removed following the resolution of a crisis,
  this is a finding.

  Domain Controllers:

  Open PowerShell.

  Enter Search-ADAccount –AccountExpiring | FT Name, AccountExpirationDate.

  If AccountExpirationDate has been defined and is not within 72 hours for an
  emergency administrator account, this is a finding.

  Member servers and standalone systems:

  Open Command Prompt.

  Run Net user [username], where [username] is the name of the emergency
  account.

  If Account expires has been defined and is not within 72 hours for an
  emergency administrator account, this is a finding."
  desc "fix", "Remove emergency administrator accounts after a crisis has been
  resolved or configure the accounts to automatically expire within 72 hours.

  Domain accounts can be configured with an account expiration date, under
  Account properties.

  Local accounts can be configured to expire with the command Net user
  [username] /expires:[mm/dd/yyyy], where username is the name of the temporary
  user account."

  domain_role = command('wmic computersystem get domainrole | Findstr /v DomainRole').stdout.strip
  emergency_accounts_list = input('emergency_accounts')
  emergency_accounts_data = []
  
  if emergency_accounts_list == [nil]
    impact 0.0
    describe 'This control is not applicable as no emergency accounts were listed as an input' do
      skip 'This control is not applicable as no emergency accounts were listed as an input'
    end
  else
    if domain_role == '4' || domain_role == '5'
      emergency_accounts_list.each do |emergency_account|
        emergency_accounts_data << json({ command: "Get-ADUser -Identity #{emergency_account} -Properties WhenCreated, AccountExpirationDate | Select-Object -Property SamAccountName, @{Name='WhenCreated';Expression={$_.WhenCreated.ToString('yyyy-MM-dd')}}, @{Name='AccountExpirationDate';Expression={$_.AccountExpirationDate.ToString('yyyy-MM-dd')}}| ConvertTo-Json"}).params
      end
      if emergency_accounts_data.empty?
        impact 0.0
        describe 'This control is not applicable as account information was not found for the listed emergency accounts' do
          skip 'This control is not applicable as account information was not found for the listed emergency accounts'
        end
      else
        emergency_accounts_data.each do |emergency_account|
          account_name = emergency_account.fetch("SamAccountName")
          if emergency_account.fetch("WhenCreated") == nil
            describe "#{account_name} account's creation date" do
              subject { emergency_account.fetch("WhenCreated") }
              it { should_not eq nil}
            end
          elsif emergency_account.fetch("AccountExpirationDate") == nil
            describe "#{account_name} account's expiration date" do
              subject { emergency_account.fetch("AccountExpirationDate") }
              it { should_not eq nil}
            end
          else
            creation_date = Date.parse(emergency_account.fetch("WhenCreated"))
            expiration_date = Date.parse(emergency_account.fetch("AccountExpirationDate"))
            date_difference = expiration_date.mjd - creation_date.mjd
            describe "Account expiration set for #{account_name}" do
              subject { date_difference }
              it { should cmp <= input('emergency_account_period')}
            end
          end
        end
      end

    else
      emergency_accounts_list.each do |emergency_account|
        emergency_accounts_data << json({ command: "Get-LocalUser -Name #{emergency_account} | Select-Object -Property Name, @{Name='PasswordLastSet';Expression={$_.PasswordLastSet.ToString('yyyy-MM-dd')}}, @{Name='AccountExpires';Expression={$_.AccountExpires.ToString('yyyy-MM-dd')}} | ConvertTo-Json"}).params
      end
      if emergency_accounts_data.empty?
        impact 0.0
        describe 'This control is not applicable as account information was not found for the listed emergency accounts' do
          skip 'This control is not applicable as account information was not found for the listed emergency accounts'
        end
      else
        emergency_accounts_data.each do |emergency_account|
          user_name = emergency_account.fetch("Name")
          if emergency_account.fetch("PasswordLastSet") == nil
            describe "#{user_name} account's password last set date" do
              subject { emergency_account.fetch("PasswordLastSet") }
              it { should_not eq nil}
            end
          elsif emergency_account.fetch("AccountExpires") == nil
            describe "#{user_name} account's expiration date" do
              subject { emergency_account.fetch("AccountExpires") }
              it { should_not eq nil}
            end
          else
            password_date = Date.parse(emergency_account.fetch("PasswordLastSet"))
            expiration_date = Date.parse(emergency_account.fetch("AccountExpires"))
            date_difference = expiration_date.mjd - password_date.mjd
            describe "Account expiration set for #{user_name}" do
              subject { date_difference }
              it { should cmp <= input('emergency_account_period')}
            end
          end
        end
      end
    end
  end
end